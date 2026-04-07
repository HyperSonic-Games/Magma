package Physics

import "vendor:box2d"
import "../../Types"
import "../../Util"

World :: struct {_: i32}

EARTH_GRAVITY : Types.Vector2f : {0, -9.8}

CreateWorld :: proc(
    contact_damping_ration: f32 = 0,
    contact_hertz: f32 = 0,
    enable_continuous_collision: bool = true,
    can_bodies_sleep: bool = true,
    gravity: Types.Vector2f = EARTH_GRAVITY,
    hit_even_threshold: f32 = 1,
    max_contact_push_speed: f32 = 1,
    max_linear_speed: f32 = 100,
    restitution_threshold: f32 = 0.5,

) -> World {
    world_def := box2d.DefaultWorldDef()

    world_def.contactDampingRatio = contact_damping_ration
    world_def.contactHertz = contact_hertz
    world_def.enableContinuous = enable_continuous_collision
    world_def.enableSleep = can_bodies_sleep
    world_def.gravity = gravity
    world_def.hitEventThreshold = hit_even_threshold
    world_def.maxContactPushSpeed = max_contact_push_speed
    world_def.maximumLinearSpeed= max_linear_speed
    world_def.restitutionThreshold = restitution_threshold
    
    return transmute(World)box2d.CreateWorld(world_def)
}