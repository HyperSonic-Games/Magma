package Util

import "core:strings"
import "core:fmt"
import "core:encoding/ansi"
import "vendor:sdl2"

LogLevel :: enum {
    DEBUG,
    INFO,
    WARN,
    ERROR,
}

log :: proc(level: LogLevel, component_name: string, format: string, args: ..any) {
    prefix := fmt.aprintf("[MAGMA/%s]: ", component_name)

    full_msg := fmt.aprintf(format, args) if (len(args)) > 0 else format

    if (level == .DEBUG && ODIN_DEBUG == true) {
        fmt.printfln("%s<DEBUG> ~ %s", prefix, full_msg)
    }
    else if (level == .INFO) {
        fmt.printfln(ansi.CSI + ansi.FG_CYAN + ansi.SGR + "%s<INFO> ~ %s" + ansi.CSI + ansi.FG_WHITE, prefix, full_msg)
    }
    else if (level == .WARN) {
        fmt.printfln(ansi.CSI + ansi.FG_YELLOW + ansi.SGR + "%s<WARN> ~ %s" + ansi.CSI + ansi.FG_WHITE, prefix, full_msg)
    }
    else if (level == .ERROR) {
        if (ODIN_DEBUG) {
            fmt.eprintfln(ansi.CSI + ansi.FG_RED + ansi.SGR + "%s<ERROR> ~ %s" + ansi.CSI + ansi.FG_WHITE, prefix, full_msg)
        }
        else {
            full_msg_cstring := strings.clone_to_cstring(full_msg)
            sdl2.ShowSimpleMessageBox({.ERROR}, "MAGMA_ENGINE", full_msg_cstring, nil)
            free(&full_msg_cstring)
        }
    }

    free(&prefix)
    if len(args) > 0 {
        free(&full_msg)
    }
}
