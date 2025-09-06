package Raw

import "core:time"
import "core:net"
import "core:thread"
import "core:sync"
import "../../../../Basic"
import "../../../../../Util"
import m_net "../../../../"

// Type of the user-defined function that processes incoming UDP packets.
// The handler receives the packet and the client's address and returns a response to send back.
ServerMsgHandler :: #type proc(packet: Basic.Packet, client_addr: Basic.IPAddr) -> Basic.Packet

// Structure representing a UDP server
UDPServer :: struct {
    // Flag indicating whether the server uses IPv4 (true) or IPv6 (false)
    is_ipv4: bool,

    // Server age in ticks (currently unused; can track uptime)
    age: u128,

    // Internal handle to the server's UDP socket
    socket: Basic.UDP_SocketHandle,

    // IP address bound to the server socket
    server_address: Basic.IPAddr,

    // User-defined function to handle incoming packets
    msg_handler: ServerMsgHandler,

    // Optional mutex to allow the message handler safe access to shared program data
    data_mutex: ^sync.Mutex,

    // Thread running the server's worker loop
    internal_worker_thread: thread.Thread,

    // Pointer to boolean used as an atomic stop/start flag for multithreading
    internal_running: ^bool
}

/*
* InitUDPServerIPV4 Creates a new UDP server using IPv4
*
* @param addr The IPv4 address to bind the server
* @param port The UDP port number
* @param msg_handler User-defined packet handler
* @param mutex_ptr Optional pointer to a mutex for thread safety
* @return (^UDPServer, bool) Returns a pointer to the server and true on success
*/
InitUDPServerIPV4 :: proc(
    addr: m_net.IPV4,
    port: u16,
    msg_handler: ServerMsgHandler,
    mutex_ptr: ^sync.Mutex = nil,
) -> (^UDPServer, bool) {
    socket := Basic.OpenUDPSocket(port, .IP4, cast(net.IP4_Address)addr)
    if socket == nil {
        Util.log(.ERROR, "MAGMA_NET_PROTOCALS_CLIENT_SERVER_RAW_UDP_INIT_SERVER_IPV4",
                 "returned nil when a UDP_SocketHandle was expected")
        return nil, false
    }

    server := new(UDPServer)
    server.age = 0
    server.is_ipv4 = true
    server.server_address = cast(net.IP4_Address)addr
    server.socket = socket.(Basic.UDP_SocketHandle)
    server.msg_handler = msg_handler
    server.internal_running = new(bool)
    server.data_mutex = mutex_ptr

    // Ensure the server is initially stopped
    sync.atomic_store(server.internal_running, false)
    return server, true
}

/*
* InitUDPServerIPV6 Creates a new UDP server using IPv6
*
* @param addr The IPv6 address to bind the server
* @param port The UDP port number
* @param msg_handler User-defined packet handler
* @param mutex_ptr Optional pointer to a mutex for thread safety
* @return (^UDPServer, bool) Returns a pointer to the server and true on success
*/
InitUDPServerIPV6 :: proc(
    addr: m_net.IPV6,
    port: u16,
    msg_handler: ServerMsgHandler,
    mutex_ptr: ^sync.Mutex = nil,
) -> (^UDPServer, bool) {
    socket := Basic.OpenUDPSocket(port, .IP6, cast(net.IP6_Address)addr)
    if socket == nil {
        Util.log(.ERROR, "MAGMA_NET_PROTOCALS_CLIENT_SERVER_RAW_UDP_INIT_SERVER_IPV6",
                 "returned nil when a UDP_SocketHandle was expected")
        return nil, false
    }

    server := new(UDPServer)
    server.age = 0
    server.is_ipv4 = false
    server.server_address = cast(net.IP6_Address)addr
    server.socket = socket.(Basic.UDP_SocketHandle)
    server.msg_handler = msg_handler
    server.internal_running = new(bool)
    server.data_mutex = mutex_ptr

    sync.atomic_store(server.internal_running, false)
    return server, true
}

// Generic InitUDPServer procedure that can select between IPv4 and IPv6
InitUDPServer :: proc { InitUDPServerIPV4, InitUDPServerIPV6 }

/*
* UDPServerTick Processes incoming UDP packets and sends responses
*
* @param server Pointer to the UDPServer instance
*/
@private
UDPServerTick :: proc(server: ^UDPServer) {
    buf := make([]byte, 4096)          // Temporary buffer for incoming packet
    client_addr := Basic.IPAddr{}      // To store the client's address

    // Receive a packet from any client (non-blocking)
    bytes_read, address, port := Basic.ReciveUDPSocket(server.socket, buf)
    if bytes_read == 0 {
        return // No packet received
    }

    packet := buf[:bytes_read]

    // Protect the user handler with mutex if provided
    if server.data_mutex != nil {
        sync.mutex_lock(server.data_mutex)
    }
    response := server.msg_handler(packet, client_addr)
    if server.data_mutex != nil {
        sync.mutex_unlock(server.data_mutex)
    }

    // Send a response if the handler returned data
    if len(response) > 0 {
        _, _ = Basic.SendUDPSocket(server.socket, response, client_addr, port)
    }
}

/*
* Worker loop for the server running in a separate thread
*
* @param thread_cxt Pointer to the thread context containing the server
*/
@private
Worker :: proc(thread_cxt: ^thread.Thread) {
    server := cast(^UDPServer)thread_cxt.data

    for sync.atomic_load(server.internal_running) {
        UDPServerTick(server)
        thread.yield() // Allow other threads to run
    }
}

/*
* RunUDPServer Starts the server in a new worker thread
*
* @param server Pointer to the UDPServer instance
*/
RunUDPServer :: proc(server: ^UDPServer) {
    if sync.atomic_load(server.internal_running) {
        return // Already running
    }
    sync.atomic_store(server.internal_running, true)

    server.internal_worker_thread = thread.create(Worker)^
    server.internal_worker_thread.data = server
    thread.start(&server.internal_worker_thread)
}

/*
* StopUDPServer Stops the running UDP server and frees resources
*
* @param server Pointer to the UDPServer instance
*/
StopUDPServer :: proc(server: ^UDPServer) {
    Util.log(.INFO, "MAGMA_NET_PROTOCALS_CLIENT_SERVER_RAW_UDP_STOP_SERVER",
             "Stopping UDP server")

    // Stop the worker loop
    sync.atomic_store(server.internal_running, false)
    thread.join(&server.internal_worker_thread)

    // Close the server socket
    Basic.CloseUDPSocket(server.socket)

    // Free memory
    free(server.internal_running)
    free(server)
}
