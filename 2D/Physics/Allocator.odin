package Physics

import "core:mem"

import "vendor:box2d"

import "base:runtime"
import "core:mem/tlsf"
import "core:mem/virtual"

import "../../Util"

@(private)
BackingMemoryArena: virtual.Arena

@(private)
TLSFAllocator: tlsf.Allocator


@(private)
Allocate :: proc "c" (size: u32, alignment: i32) -> rawptr {
    context = runtime.default_context()

    allocator := tlsf.allocator(&TLSFAllocator)
    data, _ := mem.alloc(cast(int)size, cast(int)alignment)

    return data
}

@(private)
Free :: proc "c" (mem: rawptr) {
    context = runtime.default_context()

    allocator := tlsf.allocator(&TLSFAllocator)
    mem_free(mem, allocator)
}


Assert :: proc "c" (condition, file_name: cstring, line_number: i32) -> i32 {
    context = runtime.default_context()
    Util.Log(
        .ERROR_NO_ABORT,
        "MAGMA",
        "2D_PHYSICS_BOX2D_ASSERT",
        "Box2D has trigered an assert with condition: %s in file: %s at line: %d\nshuting down Box2D",
        condition, file_name, line_number
    )
    return 1
}

@(init, private)
CreateAllocator :: proc "contextless" () {
    context = runtime.default_context()

    err := virtual.arena_init_growing(&BackingMemoryArena)
    if err != .None {
        Util.Log(.ERROR, "MAGMA", "2D_PHYSICS_CREATE_ALLOCATOR", "Could not create an allocator: %s", err)
    }

    err1 := tlsf.init_from_allocator(
        &TLSFAllocator,
        virtual.arena_allocator(&BackingMemoryArena),
        5 * runtime.Kilobyte,
        1 * runtime.Kilobyte,
    )
    if err1 != .None {
        Util.Log(.ERROR, "MAGMA", "2D_PHYSICS_CREATE_ALLOCATOR", "Could not init the TLSF allocator: %s", err1)
    }

    box2d.SetAllocator(Allocate, Free)

}

@(init, private)
SetupAssert :: proc "contextless" () {
    box2d.SetAssertFcn(Assert)
}

@(fini, private)
ShutdownAllocator :: proc "contextless" () {
    context = runtime.default_context()
    tlsf.destroy(&TLSFAllocator)
    virtual.arena_destroy(&BackingMemoryArena)
}

