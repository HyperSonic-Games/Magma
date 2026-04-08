package Util


VERBOSE_LOGGING :: #config(magma_engine_verbose_logging, false)

import "base:runtime"
import "core:strings"
import "core:fmt"
import "core:terminal/ansi"
import "vendor:sdl2"
import "core:reflect"
import "base:intrinsics"

LogLevel :: enum {
    DEBUG,
    VERBOSE,
    INFO,
    WARN,
    ERROR,
    ERROR_NO_ABORT,
}

/*
logs a message to stdout/stderr
calls to log with the .DEBUG level will only output if your game is compiled as a debug build
calling with level ERROR will cause a runtime trap if you do not want this use ERROR_NO_ABORT
@param level the level to log at. options are (DEBUG, VERBOSE, INFO, WARN, ERROR, ERROR_NO_ABORT)
@param namespace the namspace to log from (this is used to seprerate the engine's loging output with anything else)
@param component_name the name associated to what called this function
@param format a regular odin format string followed by the vars to print out
*/
Log :: proc(level: LogLevel, namespace: string, component_name: string, format: string, args: ..any) {
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
    else if (level == .ERROR || level == .ERROR_NO_ABORT) { // Leaks memory but it's an error state so the program is crashing anyways
        if (ODIN_DEBUG) {
            if level == .ERROR {
                fmt.eprintfln(ansi.CSI + ansi.FG_RED + ansi.SGR + "%s<ERROR> ~ %s" + ansi.CSI + ansi.FG_WHITE, prefix, full_msg)
            }
            else {
                fmt.eprintfln(ansi.CSI + ansi.FG_RED + ansi.SGR + "%s<ERROR_NO_ABORT> ~ %s" + ansi.CSI + ansi.FG_WHITE, prefix, full_msg)
            }
            if level != .ERROR_NO_ABORT {
                runtime.debug_trap() // Hey debuger we messed up come see
            }
        }
        else {
            full_msg_cstring := strings.clone_to_cstring(full_msg)
            sdl2.ShowSimpleMessageBox({.ERROR}, strings.clone_to_cstring(namespace), full_msg_cstring, nil)
            delete(full_msg_cstring)
            if level != .ERROR_NO_ABORT {
                runtime.trap() // CRASH AND BURN
            }
        }
    }

    delete(prefix)
    if len(args) > 0 {
        delete(full_msg)
    }
}

DumpStruct :: proc(strct: $T) where intrinsics.type_is_struct(T) {
    strct := strct
	id := typeid_of(T)
	
	names   := reflect.struct_field_names(id)
	types   := reflect.struct_field_types(id)
	offsets := reflect.struct_field_offsets(id)
	tags    := reflect.struct_field_tags(id)

	fmt.printf("%v :: struct {{\n", id)
	
	for name, i in names {
		// Calculate the pointer to the specific field
		field_ptr := rawptr(uintptr(&strct) + offsets[i])
		// Create an 'any' so fmt knows how to print the value
		field_val := any{field_ptr, types[i].id}

		tag_str := ""
		if tags[i] != "" {
			tag_str = fmt.tprintf(" `%s`", tags[i])
		}

		fmt.printf("\t%s: %v = %v,%s\n", name, types[i], field_val, tag_str)
	}
	
	fmt.println("}")
}
