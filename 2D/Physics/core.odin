package Physics

import "../../Types"
import "vendor:box2d"

@private
PPM: f64 = 100.0 // SDL Pixels to Box2D Meters 100 Pixels -> 1 Meter

DEFAULT_GRAVITY_CONST : [2]f32 : {0, -9.80665} // Gravitational vector constant of Earth in m/s^2
DEFAULT_TIME_STEP : f64 : 1.0 / 60.0;  // 0.01666 seconds per physics update

@private
PixelsToBox2d :: proc(x: int, y: int, screen_height: int) -> Types.Vector2f {
    box2d_data: Types.Vector2f
    x_m := f64(x) / PPM
    y_m := f64(screen_height - y) / PPM // Flip Y-axis

    box2d_data = Types.Vector2fSetX(box2d_data, x_m)
    box2d_data = Types.Vector2fSetY(box2d_data, y_m)

    return box2d_data
}

@private
Box2dToPixels :: proc(pos: Types.Vector2f, screen_height: int) -> Types.Vector2f {
    x_px := Types.Vector2fGetX(pos) * PPM
    y_px := (f64(screen_height) - Types.Vector2fGetY(pos) * PPM) // Flip Y-axis

    pixel_vec: Types.Vector2f
    pixel_vec = Types.Vector2fSetX(pixel_vec, x_px)
    pixel_vec = Types.Vector2fSetY(pixel_vec, y_px)

    return pixel_vec
}

PhysicsEnv ::  struct {
    world_handle: box2d.WorldId
}



InitPhysics :: proc(gravity_constant: [2]f32 = DEFAULT_GRAVITY_CONST, time_step: f64 = DEFAULT_TIME_STEP) -> PhysicsEnv {
    world : box2d.WorldDef = box2d.DefaultWorldDef()
    world.enableContinous = true
    world.enableSleep = true
    world.gravity = gravity_constant
    world_id := box2d.CreateWorld(world)
    env := new(PhysicsEnv)
    env.world_handle = world_id
    return env^
}

DestroyPhysics :: proc(env: ^PhysicsEnv) {
    free(env)
}