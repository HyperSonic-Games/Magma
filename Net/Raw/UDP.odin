package Raw

import "../../Util"

import "core:net"

/*
 * OpenUDPSocket
 *
 * Creates and configures a UDP socket optimized for low-latency game networking.
 *
 * @param port
 *   The local port to bind the socket to. If 0, no bind occurs (useful for clients).
 *
 * @param addr_type
 *   The IP address family for the socket (e.g., IPv4, IPv6).
 *
 * @param addr
 *   The local IP address to bind to. Used when acting as a server or listener.
 *
 * @param is_blocking
 *   If true, socket operations block until completion. If false, the socket is non-blocking
 *   and suitable for integration into a game engine's main loop.
 *
 * @param allow_broadcast
 *   If true, enables sending to and receiving from broadcast addresses.
 *
 * @return
 *   A Maybe(UDP_SocketHandle):
 *     - Contains a valid UDP socket handle on success.
 *     - Returns nil if socket creation, configuration, or binding fails.
 *
 * @notes
 *   - Receive buffer is set to 512 KB; send buffer to 256 KB to handle bursts without dropping packets.
 *   - UDP does not use TCP_Nodelay or Keep-Alive.
 *   - Receive and send timeouts are set to 0 (non-blocking style) for integration into a game loop.
 *   - In debug builds, .Reuse_Address is enabled to allow rapid server restarts.
 *
 * @example
 *   maybe_udp := Raw.OpenUDPSocket(7777, .INET, net.IPv4(0,0,0,0), false, true)
 *   if maybe_udp != nil {
 *       // UDP socket ready for use
 *       udp_sock := maybe_udp
 *   }
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
        Util.log(.ERROR, "RawUDPHandler", "UDP Socket creation failed: %s", err)
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
            Util.log(.ERROR, "RawUDPHandler", "Failed to bind UDP socket: %s", err)
            net.close(sock)
            return nil
        }
    }

    return sock.(net.UDP_Socket)
}