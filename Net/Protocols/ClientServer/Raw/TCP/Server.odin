package Raw

import "core:time"
import "core:net"
import "core:thread"
import "core:sync"
import "../../../../Basic"
import "../../../../../Util"
import m_net "../../../../"

ServerMsgHandler :: #type proc(packet: Basic.Packet) -> Basic.Packet

TCPServer :: struct {
    // Flag indicating whether the server is using IPv4 (true) or IPv6 (false) protocol
    is_ipv4: bool,

    // Server age in how many times the server has ticked (currently unused; can track uptime or ticks)
    age: u128,

    // Number of currently connected clients
    clients_count: u128,

    // Internal handle to the server's underlying TCP socket
    socket: Basic.TCP_SocketHandle,

    // IP address bound to the server socket
    server_address: Basic.IPAddr,

    // User-defined function pointer to process incoming packets
    msg_handler: ServerMsgHandler,

    // User-provided mutex to safely allow msg_handler to access shared program data
    data_mutex: ^sync.Mutex,

    // Internal list of connected client socket handles
    clients:                [dynamic]Basic.TCP_SocketHandle,

    // Thread running the server worker loop
    internal_worker_thread: thread.Thread,

    // Pointer to a boolean used as an atomic stop/start flag for multithreading
    internal_running: ^bool,
}

/*
*  InitTCPServerIPV4 Creates a new server using the IPv4 protocol
*
* @param addr The IPv4 address the server will bind to
* @param port The TCP port number to listen on
* @param msg_handler A user-defined function that handles incoming packets
* @param mutex_ptr Optional pointer to a user-provided mutex to safely access shared data
* @return (^TCPServer, bool) Returns a pointer to the newly created server and true on success, false if socket creation failed
*/
InitTCPServerIPV4 :: proc(
    addr: m_net.IPV4,
    port: u16,
    msg_handler: ServerMsgHandler,
    mutex_ptr: ^sync.Mutex = nil,
) -> (^TCPServer, bool) {
    socket := Basic.OpenTCPSocket(port, .IP4, cast(net.IP4_Address)addr)
    if socket == nil {
        Util.log(.ERROR, "MAGMA_NET_PROTOCALS_CLIENT_SERVER_RAW_TCP_INIT_SERVER_IPV4",
                 "returned nil when a TCP_SocketHandle was expected")
        return nil, false
    }

    server := new(TCPServer)
    server.age = 0
    server.clients_count = 0
    server.is_ipv4 = true
    server.server_address = cast(net.IP4_Address)addr
    server.socket = socket.(Basic.TCP_SocketHandle)
    server.msg_handler = msg_handler
    server.clients = make([dynamic]Basic.TCP_SocketHandle)
    server.internal_running = new(bool)

    server.data_mutex = mutex_ptr

    // ensure stopped by default
    sync.atomic_store(server.internal_running, false)
    return server, true
}

/*
*  InitTCPServerIPV6 Creates a new server using the IPv6 protocol
*
* @param addr The IPv6 address the server will bind to
* @param port The TCP port number to listen on
* @param msg_handler A user-defined function that handles incoming packets
* @param mutex_ptr Optional pointer to a user-provided mutex to safely access shared data
* @return (^TCPServer, bool) Returns a pointer to the newly created server and true on success, false if socket creation failed
*/
InitTCPServerIPV6 :: proc(
    addr: m_net.IPV6,
    port: u16,
    msg_handler: ServerMsgHandler,
    mutex_ptr: ^sync.Mutex = nil,
) -> (^TCPServer, bool) {
    socket := Basic.OpenTCPSocket(port, .IP6, cast(net.IP6_Address)addr)
    if socket == nil {
        Util.log(.ERROR, "MAGMA_NET_PROTOCALS_CLIENT_SERVER_RAW_TCP_INIT_SERVER_IPV6",
                 "returned nil when a TCP_SocketHandle was expected")
        return nil, false
    }

    server := new(TCPServer)
    server.age = 0
    server.clients_count = 0
    server.is_ipv4 = false
    server.server_address = cast(net.IP6_Address)addr
    server.socket = socket.(Basic.TCP_SocketHandle)
    server.msg_handler = msg_handler
    server.clients = make([dynamic]Basic.TCP_SocketHandle)
    server.internal_running = new(bool)

    server.data_mutex = mutex_ptr

    sync.atomic_store(server.internal_running, false)
    return server, true
}

InitTCPServer :: proc { InitTCPServerIPV4, InitTCPServerIPV6 }

@private
TCPServerAcceptClients :: proc(server: ^TCPServer) {
    if server.data_mutex != nil {
        sync.mutex_lock(server.data_mutex)
    }

    for {
        new_sock, _, err := net.accept_tcp(server.socket) // endpoint unused (NOTE: could be used for debug info at a later point)
        if err != .None {
            break // no more clients right now
        }

        append(&server.clients, new_sock)
        server.clients_count += 1
        Util.log(.INFO, "MAGMA_NET_PROTOCALS_CLIENT_SERVER_RAW_TCP_SERVER_ACCEPT_CLIENTS",
                 "Accepted new client, total: %d", server.clients_count)
    }

    if server.data_mutex != nil {
        sync.mutex_unlock(server.data_mutex)
    }
}

@private
TCPServerTick :: proc(server: ^TCPServer) {
    TCPServerAcceptClients(server)

    i := 0
    for i < len(server.clients) {
        client := server.clients[i]
        buf := make([]byte, 4096)

        bytes_read, ok := Basic.ReciveTCPSocket(client, buf)
        if !ok || bytes_read == 0 {
            Util.log(.INFO, "MAGMA_NET_PROTOCALS_CLIENT_SERVER_RAW_TCP_SERVER_TICK",
                     "Closing client connection")
            Basic.CloseTCPSocket(client)

            if server.data_mutex != nil {
                sync.mutex_lock(server.data_mutex)
            }
            unordered_remove(&server.clients, i)
            server.clients_count -= 1
            if server.data_mutex != nil {
                sync.mutex_unlock(server.data_mutex)
            }
            continue // don't increment i; we swapped in the last element
        }

        packet := buf[:bytes_read]

        // protect user handler with user-provided mutex
        if server.data_mutex != nil {
            sync.mutex_lock(server.data_mutex)
        }
        response := server.msg_handler(packet)
        if server.data_mutex != nil {
            sync.mutex_unlock(server.data_mutex)
        }

        if len(response) > 0 {
            _, _ = Basic.SendTCPSocket(client, response)
        }

        i += 1
    }
}

@private
Worker :: proc(thread_cxt: ^thread.Thread) {
    server := cast(^TCPServer)thread_cxt.data

    for sync.atomic_load(server.internal_running) {
        TCPServerTick(server)
        thread.yield() // low latency; relies on non-blocking sockets
    }
}

/*
*  RunTCPServer Starts the server in a new worker thread
*
* @param server Pointer to the TCPServer instance to run
* @return void
*/
RunTCPServer :: proc(server: ^TCPServer) {
    if sync.atomic_load(server.internal_running) {
        return // already running
    }
    sync.atomic_store(server.internal_running, true)

    server.internal_worker_thread = thread.create(Worker)^
    server.internal_worker_thread.data = server
    thread.start(&server.internal_worker_thread)
}


/*
*  StopTCPServer Stops the running server, closes all clients and the server socket, and frees resources
*
* @param server Pointer to the TCPServer instance to stop
* @return void
*/
StopTCPServer :: proc(server: ^TCPServer) {
    Util.log(.INFO, "MAGMA_NET_PROTOCALS_CLIENT_SERVER_RAW_TCP_STOP_SERVER",
             "Stopping with %d clients currently connected", server.clients_count)

    sync.atomic_store(server.internal_running, false)
    thread.join(&server.internal_worker_thread)

    // close all client sockets
    for client in server.clients {
        Basic.CloseTCPSocket(client)
    }
    server.clients_count = 0

    // close server socket
    Basic.CloseTCPSocket(server.socket)
    delete(server.clients)
    free(server.internal_running)
    free(server)
}
