package Physics

import "../../Util"
import "../../Types"


PIXELS_PER_METER : f32 : #config(magma_engine_physics_pixels_per_meter, 100.00)

Meters :: distinct f32
Seconds :: distinct f32
Kilograms :: distinct f32
Newtons :: distinct f32 // 1 N = 1 kg * m / s^2
Radians :: distinct f32

// M/s^2
EARTH_GRAVITY :: Types.Vector2f{0, -9.87}

MetersToPixels :: #force_inline proc(meters: Meters) -> f32 {
    return cast(f32)meters * PIXELS_PER_METER
}

PixelsToMeters :: #force_inline proc(pixels: f32) -> Meters {
    return cast(Meters)(pixels / PIXELS_PER_METER)
}

Body :: struct {
    pos: Types.Vector2f, // meters
    vel: Types.Vector2f, // meters / second
    force: Types.Vector2f, // newtons

    mass: Kilograms,
    inv_mass: f32, // 1 / kilograms

    rot: Radians,
    angular_vel: f32, // angular velocity (rad/sec)

    torque: f32, // torque as (newtons * meters)
    inv_inertia: f32, // 1 / (kilograms * meters^2)

    is_static: bool,
    is_lazy: bool, // only update on colisions
}

CreateBody :: proc(world: ^World, is_static: bool = false, is_lazy: bool = false) {
    body := Body{is_static = is_static, is_lazy = is_lazy}
    _, err := append(&world._bodies, body)

    if err != .None {
        Util.Log(.ERROR, "MAGMA", "2D_PHYSICS_CREATE_BODY", "Could not create a new body: %s", err)
    }
}