package Basic

import "../../Util"

import "core:net"




/*
 * OpenTCPSocket Creates and configures a TCP socket optimized for low-latency game networking.
 *
 * @param port The local port to bind the socket to. If 0, no bind occurs (useful for clients).
 *
 * @param addr_type The IP address family for the socket (e.g., IPv4, IPv6).
 *
 * @param addr The local IP address to bind to. Used when acting as a server.
 *
 * @param is_blocking If true, socket operations block until completion. If false, the socket is non-blocking and suitable for integration into a game engine's main loop.
 *
 * @param send_keepalive_msgs If true, the OS will periodically send TCP keep-alive packets to detect dead peers. Typically false for real-time games; use custom heartbeat/ping logic instead.
 *
 * @return A Maybe(TCP_SocketHandle)
 *
 */
OpenTCPSocket :: proc(
    port: u16,
    addr_type: IPAddrFamily,
    addr: IPAddr,
    is_blocking: bool = false,
    send_keepalive_msgs: bool = false
) -> Maybe(TCP_SocketHandle) {

    sock, err := net.create_socket(addr_type, .TCP)
    if err != .None {
        Util.log(.ERROR, "RawTCPHandler", "TCP Socket creation failed: %s", err)
        return nil
    }

    ENDPOINT: net.Endpoint = {addr, cast(int)port}

    // --- Core performance options ---
    net.set_option(sock, .TCP_Nodelay, true)
    net.set_option(sock, .Receive_Buffer_Size, 262144) // 256 KB
    net.set_option(sock, .Send_Buffer_Size, 131072)    // 128 KB
    net.set_option(sock, .Keep_Alive, send_keepalive_msgs)

    // --- Timeout tuning ---
    net.set_option(sock, .Receive_Timeout, 50)
    net.set_option(sock, .Send_Timeout, 200)

    // --- Reuse address for debug builds ---
    when ODIN_DEBUG {
        net.set_option(sock, .Reuse_Address, true)
    }

    // --- Blocking vs non-blocking ---
    net.set_blocking(sock, is_blocking)

    // --- Bind to port if specified ---
    if port != 0 {
        err := net.bind(sock, ENDPOINT)
        if err != .None {
            Util.log(.ERROR, "RawTCPHandler", "Failed to bind TCP socket: %s", err)
            net.close(sock)
            return nil
        }
    }

    return sock.(net.TCP_Socket)
}

/*
 * SendTCPSocket Sends a buffer of bytes over a TCP socket.
 *
 * @param socket The TCP socket handle to send data through.
 *
 * @param data A slice of bytes containing the data to send.
 *
 * @return The number of bytes successfully written. and true if the send completed without error; false if an error occurred.
 
 */
SendTCPSocket :: proc(socket: TCP_SocketHandle, data: []byte) -> (int, bool) {
    data_written, err := net.send_tcp(socket, data)

    if err != .None {
        Util.log(.ERROR, "RawTCPSendData", "Sent: %d bytes before encountering error: %s", data_written, err)
        return data_written, false
    }
    return data_written, true
}

/*
 * ReciveTCPSocket Receives data from a TCP socket into the provided buffer.
 *
 * @param socket The TCP socket handle to read data from.
 *
 * @param buf A slice of bytes that will be filled with received data.
 *
 * @return The number of bytes successfully read and true if success; false if error
 */
ReciveTCPSocket :: proc(socket: TCP_SocketHandle, buf: []byte) -> (int, bool) {
    data_read, err := net.recv_tcp(socket, buf)

    if err != .None {
        Util.log(.ERROR, "RawTCPReciveData", "Received: %d bytes before encountering error: %s", data_read, err)
        return data_read, false
    }

    return data_read, true
}
