package Physics


import "../../Types"

StepBody :: proc(body: ^Body, dt: Seconds) {

    // Linear acceleration: a = F * inv_mass
    accel := Types.Vector2f{
        body.force.x * body.inv_mass,
        body.force.y * body.inv_mass,
    }

    // Integrate velocity
    body.vel.x += accel.x * cast(f32)dt
    body.vel.y += accel.y * cast(f32)dt

    // Integrate position
    body.pos.x += body.vel.x * cast(f32)dt
    body.pos.y += body.vel.y * cast(f32)dt

    // Angular acceleration: α = torque * inv_inertia
    ang_accel := body.torque * body.inv_inertia

    // Integrate angular velocity and rotation
    body.angular_vel += ang_accel * cast(f32)dt
    body.rot += cast(Radians)body.angular_vel * cast(Radians)dt

    // Clear forces for next frame
    body.force = Types.Vector2f{0, 0}
    body.torque = 0
}