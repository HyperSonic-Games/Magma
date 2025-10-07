package Renderer


import rl "vendor:raylib"
import "core:strings"

@private
SplashImage := #load("../../Icons/MagmaEngine.png", []byte)
@private
SplashImage2 := #load("../../Icons/Splash2.png", []byte)


RenderContext :: struct {
    width:       u32,
    height:      u32,
    title:       string,

    clear_color: rl.Color,

    frame_count: u128,

    // camera control
    camera:      rl.Camera3D,
    move_speed:  f32,
    mouse_sense: f32,
    yaw, pitch:  f32,
    distance: f32,
}

Init :: proc(width: u32, height: u32, title: string, camera_fov: f32, camera_use_perspective: bool = false) -> ^RenderContext {
    temp_title := strings.clone_to_cstring(title, context.temp_allocator)
    rl.InitWindow(cast(i32)width, cast(i32)height, temp_title)

    ctx := new(RenderContext)
    ctx.width = width
    ctx.height = height
    ctx.title = title
    ctx.clear_color = rl.RAYWHITE
    ctx.frame_count = 0

    ctx.camera.position = rl.Vector3{0, 10, 10}
    ctx.camera.target   = rl.Vector3{0, 0, 0}
    ctx.camera.up       = rl.Vector3{0, 1, 0}
    ctx.camera.fovy     = camera_fov
    if camera_use_perspective {ctx.camera.projection = .PERSPECTIVE} else {ctx.camera.projection = .ORTHOGRAPHIC}
    ctx.move_speed = 10.0
    ctx.mouse_sense = 0.15
    ctx.yaw = 0
    ctx.pitch = 0
    ctx.distance = 10.0

    splash_image := rl.LoadImageFromMemory(".png", &SplashImage, cast(i32)len(SplashImage))
    splash_image2 := rl.LoadImageFromMemory(".png", &SplashImage2, cast(i32)len(SplashImage2))


    return ctx
}


