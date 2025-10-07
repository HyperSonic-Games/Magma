package Renderer

import rl "vendor:raylib"
import "core:math"
import "../../Types"

// Camera mode enum
CameraMode :: enum {
    FirstPerson,  // Camera rotates in place
    ThirdPerson   // Camera orbits around a target
}

// Unified RotateCamera
RotateCamera :: proc(ctx: ^RenderContext, yaw, pitch: Types.Radians, mode: CameraMode, target: ^Types.Vector3f) {
    if mode == .FirstPerson {
        // FirstPerson: rotate direction vector
        dir := Types.Vector3f{
            ctx.camera.target.x - ctx.camera.position.x,
            ctx.camera.target.y - ctx.camera.position.y,
            ctx.camera.target.z - ctx.camera.position.z,
        }

        // Apply yaw (Y axis)
        sin_y := math.sin(yaw)
        cos_y := math.cos(yaw)
        dir = Types.Vector3f{
            dir[0] * cos_y - dir[2] * sin_y,
            dir[1],
            dir[0] * sin_y + dir[2] * cos_y,
        }

        // Apply pitch (X axis)
        sin_p := math.sin(pitch)
        cos_p := math.cos(pitch)
        dir = Types.Vector3f{
            dir[0],
            clamp(dir[1] * cos_p - dir[2] * sin_p, -math.abs(dir[2]) * 0.99, math.abs(dir[2]) * 0.99),
            dir[1] * sin_p + dir[2] * cos_p,
        }

        ctx.camera.target.x = ctx.camera.position.x + dir[0]
        ctx.camera.target.y = ctx.camera.position.y + dir[1]
        ctx.camera.target.z = ctx.camera.position.z + dir[2]

    } else if mode == .ThirdPerson {
        // Third-person: orbit around target
        offset := Types.Vector3f{
            ctx.camera.position.x - target.x,
            ctx.camera.position.y - target.y,
            ctx.camera.position.z - target.z,
        }

        // Yaw (around Y)
        sin_y := math.sin(yaw)
        cos_y := math.cos(yaw)
        offset = Types.Vector3f{
            offset[0] * cos_y - offset[2] * sin_y,
            offset[1],
            offset[0] * sin_y + offset[2] * cos_y,
        }

        // Pitch (around X)
        sin_p := math.sin(pitch)
        cos_p := math.cos(pitch)
        offset = Types.Vector3f{
            offset[0],
            offset[1] * cos_p - offset[2] * sin_p,
            offset[1] * sin_p + offset[2] * cos_p,
        }

        // Clamp vertical to avoid flipping
        offset[1] = clamp(offset[1], -math.abs(offset[2]) * 0.99, math.abs(offset[2]) * 0.99)

        // Update camera position
        ctx.camera.position.x = target.x + offset[0]
        ctx.camera.position.y = target.y + offset[1]
        ctx.camera.position.z = target.z + offset[2]

        // Look at target
        ctx.camera.target.x = target.x
        ctx.camera.target.y = target.y
        ctx.camera.target.z = target.z
    }
}
