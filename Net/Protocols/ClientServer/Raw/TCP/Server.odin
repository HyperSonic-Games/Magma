package Raw

import "core:net"
import "core:thread"
import "core:sync"
import "../../../../Basic"
import "../../../../../Util"
import m_net"../../../../"

// User-defined packet handler
ServerMsgHandler :: #type proc(packet: Basic.Packet) -> Basic.Packet

TCPServer :: struct {
    is_ipv4: bool,
    age: u128,
    clients_count: u128,
    socket: Basic.TCP_SocketHandle,
    server_address: Basic.IPAddr,
    msg_handler: ServerMsgHandler,
    is_nonblocking: bool,
    data_mutex: ^sync.Mutex, // Provided by the user if threaded mode
    clients: [dynamic]Basic.TCP_SocketHandle // Used in ALL modes now ✅
}

InitTCPServerIPV4 :: proc(
    addr: m_net.IPV4,
    port: u16,
    msg_handler: ServerMsgHandler,
    mutex_ptr: ^sync.Mutex = nil,
    is_non_blocking: bool = true
) -> (^TCPServer, bool) {
    socket := Basic.OpenTCPSocket(port, .IP4, cast(net.IP4_Address)addr, is_non_blocking)
    if socket == nil {
        Util.log(.ERROR, "RawTCPServerIPV4Init", "returned nil when a TCP_SocketHandle was expected")
        return nil, false
    }

    server := new(TCPServer)
    server.age = 0
    server.clients_count = 0
    server.is_ipv4 = true
    server.is_nonblocking = is_non_blocking
    server.server_address = cast(net.IP4_Address)addr
    server.socket = socket.(Basic.TCP_SocketHandle)
    server.msg_handler = msg_handler
    server.clients = make([dynamic]Basic.TCP_SocketHandle)

    if is_non_blocking {
        server.data_mutex = mutex_ptr
        if server.data_mutex == nil {
            server.data_mutex = new(sync.Mutex)
        }
    } else {
        server.data_mutex = nil
    }

    return server, true
}

InitTCPServerIPV6 :: proc(
    addr: m_net.IPV6,
    port: u16,
    msg_handler: ServerMsgHandler,
    mutex_ptr: ^sync.Mutex = nil,
    is_non_blocking: bool = true
) -> (^TCPServer, bool) {
    socket := Basic.OpenTCPSocket(port, .IP6, cast(net.IP6_Address)addr, is_non_blocking)
    if socket == nil {
        Util.log(.ERROR, "RawTCPServerIPV6Init", "returned nil when a TCP_SocketHandle was expected")
        return nil, false
    }



    server := new(TCPServer)
    server.age = 0
    server.clients_count = 0
    server.is_ipv4 = false
    server.is_nonblocking = is_non_blocking
    server.server_address = cast(net.IP6_Address)addr
    server.socket = socket.(Basic.TCP_SocketHandle)
    server.msg_handler = msg_handler
    server.clients = make([dynamic]Basic.TCP_SocketHandle)

    if is_non_blocking {
        server.data_mutex = mutex_ptr
        if server.data_mutex == nil {
            server.data_mutex = new(sync.Mutex)
        }
    } else {
        server.data_mutex = nil
    }

    return server, true
}

InitTCPServer :: proc { InitTCPServerIPV4, InitTCPServerIPV6 }

