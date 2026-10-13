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
    if level == .DEBUG && !ODIN_DEBUG {
        return
    }
    if level == .VERBOSE && !VERBOSE_LOGGING {
        return
    }

    prefix := fmt.aprintf("[%s/%s]", namespace, component_name)
    defer delete(prefix)

    full_msg := format
    
    if len(args) > 0 {
        full_msg = fmt.aprintf(format, args)
        defer delete(full_msg)
    }

    label := ""
    color_code := ""

    switch level {
    case .DEBUG:
        label = "DEBUG"
        color_code = ansi.FG_WHITE
    case .VERBOSE:
        label = "VERBOSE"
        color_code = ansi.FG_BLUE
    case .INFO:
        label = "INFO"
        color_code = ansi.FG_CYAN
    case .WARN:
        label = "WARN"
        color_code = ansi.FG_YELLOW
    case .ERROR:
        label = "ERROR"
        color_code = ansi.FG_RED
    case .ERROR_NO_ABORT:
        label = "ERROR_NO_ABORT"
        color_code = ansi.FG_RED
    }

    color := strings.join(
        []string{ansi.CSI, color_code, ansi.SGR},
        "",
        context.temp_allocator,
    )
    reset := strings.join(
        []string{ansi.CSI, ansi.RESET, ansi.SGR},
        "",
        context.temp_allocator,
    )

    output := strings.join(
        []string{color, prefix, " <", label, "> ~ ", full_msg, reset},
        "",

        context.temp_allocator,
    )

    if level == .ERROR || level == .ERROR_NO_ABORT {
        if ODIN_DEBUG {
            fmt.eprintfln("%s", output)

            if level == .ERROR {
                runtime.debug_trap()
            }
        } else {
            title := strings.clone_to_cstring(namespace)
            message := strings.clone_to_cstring(full_msg)
            defer delete(title)
            defer delete(message)

            sdl2.ShowSimpleMessageBox({.ERROR}, title, message, nil)

            if level == .ERROR {
                runtime.trap()
            }
        }
        return
    }

    fmt.printfln("%s", output)
}

DumpStruct :: proc(strct: $T) where intrinsics.type_is_struct(T) {
    strct := strct
	id := typeid_of(T)
	
	names := reflect.struct_field_names(id)
	types := reflect.struct_field_types(id)
	offsets := reflect.struct_field_offsets(id)
	tags := reflect.struct_field_tags(id)

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
