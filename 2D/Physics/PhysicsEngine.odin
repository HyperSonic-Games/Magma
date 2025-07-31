package Physics

import "core:log"
import "../../Types"
import "../../Util"
import "../Renderer"
import "core:simd"
import "core:math"
import "core:mem"
import "core:mem/virtual"


ALLOCATOR_ARENA: virtual.Arena
ALLOCATOR: mem.Allocator

@init
InitPhysicsEngineAllocator :: proc() {
    ALLOCATOR_ARENA = new(virtual.Arena)^
    _ = virtual.arena_init_growing(&ALLOCATOR_ARENA)
    ALLOCATOR = virtual.arena_allocator(&ALLOCATOR_ARENA)
}

@init
CheckSIMDEmulated :: proc() {
    when simd.IS_EMULATED {
        Util.log(.WARN, "MAGMA_PHYSICS_2D", "Using SIMD emulation physics engine performance WILL suffer")
    }
    else {
        Util.log(.INFO, "MAGMA_PHYSICS_2D", "Using native SIMD")
    }
}

@fini
CleanupPhysicsEngineAllocator :: proc() {
    free_all(ALLOCATOR)
}

PhysicsObj :: struct {
    bounding_box: []Types.Vector2,
    mass: f64,
    density: f64,
    pos: Types.Vector2f,
}

World :: struct {
    grav: Types.Vector2f // a gravity vector with direction and strength

}