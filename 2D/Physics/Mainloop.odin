package Physics

import "base:runtime"
import "core:container/handle_map"
import "../../Types"
import "../../Util"

PREALLOCATED_BODIES_AMOUT :: #config(magma_engine_physics_preallocated_bodies_amount, 25)


/*
A world that stores bodies and
other atributes
*/
World :: struct {
    gravity: Types.Vector2f,
    _bodies: [dynamic]Body,
    allocator: runtime.Allocator
}

InitWorld :: proc(gravity := EARTH_GRAVITY, world_allocator := context.allocator) -> ^World {
    world, err := new(World, world_allocator)

    if err != .None {
        Util.Log(.ERROR, "MAGMA", "2D_PHYSICS_INIT_WORLD", "Could not create world: %s", err)
    }

    world._bodies, err = make([dynamic]Body, PREALLOCATED_BODIES_AMOUT, world_allocator)

    if err != .None {
        Util.Log(
            .ERROR,
            "MAGMA",
            "2D_PHYSICS_INIT_WORLD",
            "Could not preallocate bodies array: %s",
            err
        )
    }

    return world

}

DestroyWorld :: proc(world: ^World)