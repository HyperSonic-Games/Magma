package Basic

import "../../Util"

import "core:net"

/*
 * OpenUDPSocket Creates and configures a UDP socket optimized for low-latency game networking.
 *
 * @param port The local port to bind the socket to. If 0, no bind occurs (useful for clients).
 *
 * @param addr_type The IP address family for the socket (e.g., IPv4, IPv6).
 *
 * @param addr The local IP address to bind to. Used when acting as a server or listener.
 *
 * @param is_blocking If true, socket operations block until completion. If false, the socket is non-blocking and suitable for integration into a game engine's main loop.
 *
 * @param allow_broadcast If true, enables sending to and receiving from broadcast addresses.
 *
 * @return A Maybe(UDP_SocketHandle)
 */
OpenUDPSocket :: proc(
    port: u16,
    addr_type: IPAddrFamily,
    addr: IPAddr,
    is_blocking: bool = false,
    allow_broadcast: bool = false
) -> Maybe(UDP_SocketHandle) {

    sock, err := net.create_socket(addr_type, .UDP)
    if err != .None {
        Util.log(.ERROR, "MAGMA_NET_BASIC_UDP_OPEN", "UDP Socket creation failed: %s", err)
        return nil
    }

    endpoint: net.Endpoint = {addr, cast(int)port}

    // --- Core performance options ---
    net.set_option(sock, .Receive_Buffer_Size, 524288)  // 512 KB receive buffer
    net.set_option(sock, .Send_Buffer_Size, 262144)     // 256 KB send buffer
    net.set_option(sock, .Broadcast, allow_broadcast)   // Enable broadcast if requested

    // --- Timeout tuning ---
    net.set_option(sock, .Receive_Timeout, 0)  // 0 = wait indefinitely / non-blocking
    net.set_option(sock, .Send_Timeout, 0)

    // --- Reuse address in debug mode ---
    when ODIN_DEBUG {
        net.set_option(sock, .Reuse_Address, true)
    }

    // --- Blocking vs non-blocking ---
    net.set_blocking(sock, is_blocking)

    // --- Bind if port specified (servers / listener sockets) ---
    if port != 0 {
        err := net.bind(sock, endpoint)
        if err != .None {
            Util.log(.ERROR, "MAGMA_NET_BASIC_UDP_OPEN", "Failed to bind UDP socket: %s", err)
            net.close(sock)
            return nil
        }
    }

    return sock.(net.UDP_Socket)
}


/*
 * SendUDPSocket
 *
 * Sends a buffer of bytes over a UDP socket to a specified endpoint.
 *
 * @param socket
 *   The UDP socket handle to send data through.
 *
 * @param data
 *   A slice of bytes containing the data to send.
 *
 * @param addr
 *   The destination IP address for the UDP packet.
 *
 * @param port
 *   The destination port for the UDP packet.
 *
 * @return The number of bytes successfully written. true if the send completed without error; false if an error occurred.
 *
 */
SendUDPSocket :: proc(socket: UDP_SocketHandle, data: []byte, addr: IPAddr, port: u16) -> (int, bool) {
    endpoint: net.Endpoint = {addr, cast(int)port}
    data_written, err := net.send_udp(socket, data, endpoint)

    if err != .None {
        Util.log(.ERROR, "MAGMA_NET_BASIC_UDP_SEND", "Sent: %d bytes before encountering error: %s", data_written, err)
        return data_written, false
    }
    return data_written, true
}

/*
 * ReciveFromUDPSocket Receives a UDP packet from a socket into the provided buffer.
 *
 * @param socket The UDP socket handle to read data from.
 *
 * @param buf A slice of bytes that will be filled with the received data.
 *
 * @return The number of bytes successfully read. The sender's IP address. The sender's port.
 */
ReciveUDPSocket :: proc(socket: UDP_SocketHandle, buf: []byte) -> (int, IPAddr, u16) {
    data_read, endpoint, err := net.recv_udp(socket, buf)

    if err != .None {
        Util.log(.ERROR, "MAGMA_NET_BASIC_UDP_RECIVE", "Received: %d bytes before encountering error: %s", data_read, err)
    }

    return data_read, endpoint.address, cast(u16)endpoint.port
}

CloseUDPSocket :: proc(socket: UDP_SocketHandle) {
    net.close(socket)
}