package main

import "base:runtime"
import "core:fmt"
import "../../GUI"

main :: proc() {
    data_handle := GUI.Copy(int(15))
    fmt.printf("data: %d", GUI.Paste(data_handle))
}