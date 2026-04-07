package Physics

import "core:math"
import "../../Types"

PIXELS_PER_METER :: #config(magma_engine_pixels_per_meter, 100)


VectorToScreenVector :: #force_inline proc(
    v: Types.Vector2f,
    window_height: int,
    object_width: f32,
    object_height: f32,
) -> Types.Vector2f {

    x := v.x * PIXELS_PER_METER
    y := cast(f32)window_height - (v.y * PIXELS_PER_METER)

    return Types.Vector2f{
        x - object_width * 0.5,
        y - object_height * 0.5,
    }
}

ScreenVectorToPhysics :: #force_inline proc(
    v: Types.Vector2f,
    window_height: int,
    object_width: f32,
    object_height: f32,
) -> Types.Vector2f {

    // convert to world pixel center
    cx := v.x + object_width * 0.5
    cy := v.y + object_height * 0.5

    return Types.Vector2f{
        cx / PIXELS_PER_METER,
        (cast(f32)window_height - cy) / PIXELS_PER_METER,
    }
}

RotationToScreenRotation :: #force_inline proc(angle_rad: f32) -> f32 {
    return -math.to_degrees(angle_rad)
}

ScreenToPhysicsRotation :: #force_inline proc(angle_deg: f32) -> f32 {
    return -math.to_radians(angle_deg)
}