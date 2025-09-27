package GUI

import "core:mem"
import "core:mem/virtual"
import "vendor:microui"

import "../Types"
import "../Util"

// configurable arena size per UI handle
@private
GUI_ALLOCATOR_MEM_SIZE :: (#config(magma_gui_allocator_mem_size, 650) * mem.Kilobyte)

Handle :: struct {
    gui_allocator_arena: virtual.Arena,
    allocator: mem.Allocator,
    cxt: ^microui.Context,
    bounding_w: Types.Vector2,
    bounding_h: Types.Vector2,
}

CreateNewHandle :: proc(w: Types.Vector2, h: Types.Vector2) -> ^Handle {
    handle := new(Handle)

    // init a static arena inside the handle
    _ = virtual.arena_init_static(
        &handle.gui_allocator_arena,
        GUI_ALLOCATOR_MEM_SIZE,
        GUI_ALLOCATOR_MEM_SIZE
    )

    // make an allocator from it
    handle.allocator = virtual.arena_allocator(&handle.gui_allocator_arena)

    // create a microui context backed by that allocator
    handle.cxt = new(microui.Context, handle.allocator)
    handle.bounding_w = w
    handle.bounding_h = h

    return handle
}


DestroyHandle :: proc(handle: ^Handle) {
    // frees everything allocated by this arena
    virtual.arena_destroy(&handle.gui_allocator_arena)
    free(handle)
}


Init :: proc(handle: ^Handle) {
    microui.init(handle.cxt)
}

