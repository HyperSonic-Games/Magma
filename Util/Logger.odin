package Util

VERBOSE_LOGGING :: #config(magma_engine_verbose_logging, false)

import "base:runtime"
import "core:strings"
import "core:fmt"
import "core:terminal/ansi"
import "vendor:sdl2"


LogLevel :: enum {
    DEBUG,
    VERBOSE,
    INFO,
    WARN,
    ERROR,
}

/*
 * log logs a message to stdout/stderr
 *
 * calls to log with the .DEBUG level will only output if your game is compiled as a debug build
 * @param level the level to log at. options are (DEBUG, INFO, WARN, ERROR)
 * @param component_name the name associated to what called this function
 * @param format a regular odin format string followed by the vars to print out
*/
log :: proc(level: LogLevel, namespace: string, component_name: string, format: string, args: ..any) {
    prefix := fmt.aprintf("[%s/%s]: ", namespace, component_name)

    full_msg := fmt.aprintf(format, args) if (len(args)) > 0 else format

    if (level == .DEBUG && ODIN_DEBUG == true) {
        fmt.printfln("%s<DEBUG> ~ %s", prefix, full_msg)
    }
    else if (level == .VERBOSE && VERBOSE_LOGGING) {
        fmt.printfln("%s<VERBOSE> ~ %s", prefix, full_msg)
    }
    else if (level == .INFO) {
        fmt.printfln(ansi.CSI + ansi.FG_CYAN + ansi.SGR + "%s<INFO> ~ %s" + ansi.CSI + ansi.FG_WHITE, prefix, full_msg)
    }
    else if (level == .WARN) {
        fmt.printfln(ansi.CSI + ansi.FG_YELLOW + ansi.SGR + "%s<WARN> ~ %s" + ansi.CSI + ansi.FG_WHITE, prefix, full_msg)
    }
    else if (level == .ERROR) { // Leaks memory but it's an error state so the program is crashing anyways
        if (ODIN_DEBUG) {
            fmt.eprintfln(ansi.CSI + ansi.FG_RED + ansi.SGR + "%s<ERROR> ~ %s" + ansi.CSI + ansi.FG_WHITE, prefix, full_msg)
            runtime.debug_trap() // Hey debuger we messed up come see
        }
        else {
            full_msg_cstring := strings.clone_to_cstring(full_msg)
            sdl2.ShowSimpleMessageBox({.ERROR}, strings.clone_to_cstring(namespace), full_msg_cstring, nil)
            delete(full_msg_cstring)
            runtime.trap() // CRASH AND BURN
        }
    }

    delete(prefix)
    if len(args) > 0 {
        delete(full_msg)
    }
}
