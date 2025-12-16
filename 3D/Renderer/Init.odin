package Renderer

import "vendor:sdl3"
import sdl3_image "vendor:sdl3/image"

import "../../Util"


RendererContext :: struct {
    gpu: ^sdl3.GPUDevice,
    window: ^sdl3.Window,
    window_width: i32,
    window_height: i32,

}


Init :: proc(
    app_name: cstring, window_name: cstring,
    width: i32, height: i32,
    debug_mode: bool = false
) -> ^RendererContext {

    ctx := new(RendererContext)

    if !sdl3.Init({.AUDIO, .VIDEO,.JOYSTICK,.HAPTIC,.GAMEPAD,.EVENTS}) {
        Util.log(.ERROR, "MAGMA_3D_RENDERER_INIT")
    }

    gpu := sdl3.CreateGPUDevice({.SPIRV}, debug_mode, "vulkan")
    if gpu == nil {
        Util.log(.ERROR, "MAGMA_3D_RENDERER_INIT", "Failed to Create GPU device: %s", sdl3.GetError())
    }

    window := sdl3.CreateWindow(window_name, width, height, {})
    if window == nil {
        Util.log(.ERROR, "MAGMA_3D_RENDERER_INIT", "Could not create a window: %s", sdl3.GetError())
    }

    if !sdl3.ClaimWindowForGPUDevice(gpu, window) {
        
    }


}