package Raw

import "../../Util"

import "core:net"




/*
 * OpenTCPSocket
 *
 * Creates and configures a TCP socket optimized for low-latency game networking.
 *
 * @param port
 *   The local port to bind the socket to. If 0, no bind occurs (useful for clients).
 *
 * @param addr_type
 *   The IP address family for the socket (e.g., IPv4, IPv6).
 *
 * @param addr
 *   The local IP address to bind to. Used when acting as a server.
 *
 * @param is_blocking
 *   If true, socket operations block until completion. If false, the socket is non-blocking
 *   and suitable for integration into a game engine's main loop.
 *
 * @param send_keepalive_msgs
 *   If true, the OS will periodically send TCP keep-alive packets to detect dead peers.
 *   Typically false for real-time games; use custom heartbeat/ping logic instead.
 *
 * @return
 *   A Maybe(TCP_SocketHandle):
 *     - Contains a valid TCP socket handle on success.
 *     - Returns nil if socket creation, configuration, or binding fails.
 *
 * @notes
 *   - Nagle's algorithm is disabled via .TCP_Nodelay to minimize latency for small packets.
 *   - Receive buffer is set to 256 KB; send buffer to 128 KB to handle bursts without dropping packets.
 *   - Receive timeout is 50ms for fast detection of stalled clients; send timeout is 200ms.
 *   - In debug builds, .Reuse_Address is enabled to allow rapid server restarts.
 *   - Broadcasting (.Broadcast) is not enabled; irrelevant for TCP.
 *   - Linger behavior is left as the kernel default.
 *
 * @example
 *   maybe_sock := Raw.OpenTCPSocket(7777, .INET, net.IPv4(0,0,0,0), false, false)
 *   if maybe_sock != nil {
 *       // socket ready for use
 *       sock := maybe_sock
 *   }
 */
OpenTCPSocket :: proc(
    port: u16,
    addr_type: IPAddrFamily,
    addr: IPAddr,
    is_blocking: bool = false,
    send_keepalive_msgs: bool = false
) -> Maybe(TCP_SocketHandle) {

    sock, err := net.create_socket(addr_type, .TCP)
    if err != nil {
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
        if err != nil {
            Util.log(.ERROR, "RawTCPHandler", "Failed to bind TCP socket: %s", err)
            net.close(sock)
            return nil
        }
    }

    return sock.(net.TCP_Socket)
}