package Physics

import "core:simd"
import "core:math"
import "core:math/ease"
import "../../Types"
import "../../Util"



@(init, private)
PhysicsSimdCheck :: proc() {
    when simd.HAS_HARDWARE_SIMD == false {
        Util.log(
            .WARN,
            "MAGMA",
            "2D_PHYSICS_SIMD_CHECK",
            "SIMD is not supported at the hardware level on this system\nand is currently being software emulated. Physics performance may be reduced."
        )
    }
}


@(private)
GetForceVector :: proc(
    mass: f32,
    acceleration: Types.Vector2f,
    gravity: Types.Vector2f
) -> Types.Vector2f {
    total_acc: #simd[2]f32 = simd.add(
        simd.from_array(acceleration),
        simd.from_array(gravity),
    )

    mass_vec: #simd[2]f32 = {mass, mass}
    return simd.to_array(simd.mul(total_acc, mass_vec))
}



EaseValue :: proc(value: f32) -> f32 {
    return ease.sine_in_out(value)
}


// --------------------------------------------------
// Friction (PHYSICALLY CONSISTENT VERSION)
// --------------------------------------------------
// Static vs kinetic is decided HERE, not by enum.
// This function assumes it is used at a contact.

@(private)
GetFrictionVector :: proc(
    v: Types.Vector2f,   // tangential velocity
    normal_force: f32,   // |Fn|
    mu_static: f32,
    mu_kinetic: f32,
    dt: f32
) -> Types.Vector2f {
    speed_sq := v.x*v.x + v.y*v.y
    if speed_sq == 0 {
        return {0, 0}
    }

    speed := math.sqrt(speed_sq)
    dir: #simd[2]f32 = {v.x / speed, v.y / speed}

    // force required to stop motion this step
    required_force := speed / dt

    max_static := mu_static * normal_force

    friction_mag: f32
    if required_force <= max_static {
        // static friction: fully cancel tangential motion
        friction_mag = -required_force
    } else {
        // kinetic friction
        friction_mag = -mu_kinetic * normal_force
    }

    return simd.to_array(
        simd.mul(dir, #simd[2]f32{friction_mag, friction_mag})
    )
}


// --------------------------------------------------
// Drag forces
// --------------------------------------------------

@(private)
GetDrag_Circle :: proc(
    v: Types.Vector2f,
    fluid_v: Types.Vector2f,
    radius: f32,
    fluid_density: f32,
    Cd_override: f32 = -1.0
) -> Types.Vector2f {
    v_rel := simd.sub(simd.from_array(v), simd.from_array(fluid_v))

    speed_sq := simd.extract(v_rel,0)*simd.extract(v_rel,0) +
                simd.extract(v_rel,1)*simd.extract(v_rel,1)
    if speed_sq == 0 { return {0,0} }

    speed := math.sqrt(speed_sq)
    dir := simd.div(v_rel, #simd[2]f32{speed, speed})

    Cd := f32(0.47)
    if Cd_override > 0 { Cd = Cd_override }

    A_proj := math.PI * radius * radius
    F_drag := 0.5 * fluid_density * Cd * A_proj * speed_sq

    return simd.to_array(simd.mul(dir, #simd[2]f32{-F_drag, -F_drag}))
}


@(private)
GetDrag_Rectangle :: proc(
    v: Types.Vector2f,
    fluid_v: Types.Vector2f,
    width: f32,
    height: f32,
    rotation_deg: f32,
    fluid_density: f32,
    Cd_override: f32 = -1.0
) -> Types.Vector2f {
    v_rel := simd.sub(simd.from_array(v), simd.from_array(fluid_v))

    speed_sq := simd.extract(v_rel,0)*simd.extract(v_rel,0) +
                simd.extract(v_rel,1)*simd.extract(v_rel,1)
    if speed_sq == 0 { return {0,0} }

    speed := math.sqrt(speed_sq)
    dir := simd.div(v_rel, #simd[2]f32{speed, speed})

    Cd := f32(1.2)
    if Cd_override > 0 { Cd = Cd_override }

    theta := math.to_radians(rotation_deg)
    cos_r := math.cos(theta)
    sin_r := math.sin(theta)

    proj_x := math.abs(cos_r*simd.extract(dir,0) + sin_r*simd.extract(dir,1))
    proj_y := math.abs(-sin_r*simd.extract(dir,0) + cos_r*simd.extract(dir,1))

    A_proj := width*proj_x + height*proj_y
    F_drag := 0.5 * fluid_density * Cd * A_proj * speed_sq

    return simd.to_array(simd.mul(dir, #simd[2]f32{-F_drag, -F_drag}))
}


@(private)
GetDrag_Capsule :: proc(
    v: Types.Vector2f,
    fluid_v: Types.Vector2f,
    rect_length: f32,
    radius: f32,
    rotation_deg: f32,
    fluid_density: f32,
    Cd_override: f32 = -1.0
) -> Types.Vector2f {
    v_rel := simd.sub(simd.from_array(v), simd.from_array(fluid_v))

    speed_sq := simd.extract(v_rel,0)*simd.extract(v_rel,0) +
                simd.extract(v_rel,1)*simd.extract(v_rel,1)
    if speed_sq == 0 { return {0,0} }

    speed := math.sqrt(speed_sq)
    dir := simd.div(v_rel, #simd[2]f32{speed, speed})

    Cd := f32(0.82)
    if Cd_override > 0 { Cd = Cd_override }

    theta := math.to_radians(rotation_deg)
    cos_r := math.cos(theta)
    sin_r := math.sin(theta)

    proj_x := math.abs(cos_r*simd.extract(dir,0) + sin_r*simd.extract(dir,1))
    proj_y := math.abs(-sin_r*simd.extract(dir,0) + cos_r*simd.extract(dir,1))

    rect_proj := rect_length*proj_x + 2*radius*proj_y
    semi_proj := math.PI * radius * radius * 0.5

    A_proj := rect_proj + semi_proj
    F_drag := 0.5 * fluid_density * Cd * A_proj * speed_sq

    return simd.to_array(simd.mul(dir, #simd[2]f32{-F_drag, -F_drag}))
}


@(private)
GetDrag_Polygon :: proc(
    v: Types.Vector2f,
    fluid_v: Types.Vector2f,
    points: []Types.Vector2f,
    rotation_deg: f32,
    fluid_density: f32,
    Cd_override: f32 = -1.0
) -> Types.Vector2f {
    v_rel := simd.sub(simd.from_array(v), simd.from_array(fluid_v))

    speed_sq := simd.extract(v_rel,0)*simd.extract(v_rel,0) +
                simd.extract(v_rel,1)*simd.extract(v_rel,1)
    if speed_sq == 0 { return {0,0} }

    speed := math.sqrt(speed_sq)
    dir := simd.div(v_rel, #simd[2]f32{speed, speed})

    Cd := f32(1.0)
    if Cd_override > 0 { Cd = Cd_override }

    theta := math.to_radians(rotation_deg)
    cos_r := math.cos(theta)
    sin_r := math.sin(theta)

    A_proj: f32 = 0
    for i := 0; i < len(points); i += 1 {
        p0 := points[i]
        p1 := points[(i+1)%len(points)]

        rp0 := Types.Vector2f{p0.x*cos_r - p0.y*sin_r, p0.x*sin_r + p0.y*cos_r}
        rp1 := Types.Vector2f{p1.x*cos_r - p1.y*sin_r, p1.x*sin_r + p1.y*cos_r}

        edge := #simd[2]f32{rp1.x - rp0.x, rp1.y - rp0.y}
        normal := #simd[2]f32{-simd.extract(edge,1), simd.extract(edge,0)}

        dot_n := simd.extract(normal,0)*simd.extract(dir,0) +
                 simd.extract(normal,1)*simd.extract(dir,1)

        if dot_n > 0 {
            edge_len := math.sqrt(
                simd.extract(edge,0)*simd.extract(edge,0) +
                simd.extract(edge,1)*simd.extract(edge,1)
            )
            A_proj += dot_n * edge_len
        }
    }

    F_drag := 0.5 * fluid_density * Cd * A_proj * speed_sq
    return simd.to_array(simd.mul(dir, #simd[2]f32{-F_drag, -F_drag}))
}