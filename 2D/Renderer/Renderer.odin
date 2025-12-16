package Renderer

import "core:fmt"
import "core:math"
import "../../Util"
import "../../Types"




@private
Frames: u128

import "vendor:sdl2"
import "vendor:sdl2/image"

GraphicsBackend :: enum {
    OPEN_GL,
    DIRECTX3D11,
    METAL,
    SOFTWARE
}

RenderContext :: struct {
    Window:   ^sdl2.Window,
    Renderer: ^sdl2.Renderer,
    RenderSurface: ^sdl2.Texture,
}

/*
 * Init Creates a new window and SDL2 renderer for drawing on
 *
 * @param app_name the internal name used by drivers like audio for identification
 * @param window_name the name displayed in the title bar in ANCI
 * @param width the width of the window in pixels
 * @param height the height of the window in pixels
 * @param GraphicsBackend defaults to OpenGL but can be set to Software on all platforms, Metal on Apple devices, and DirectX3D11 on Windows devices
 * @param debug_mode flag that tells SDL2 to run in debug mode NOTE: cluters up STDIO use only if MAGMA will not tell you the error
 * 
 * @return RenderContext a renderer context for the window you just created
*/
Init :: proc(
    app_name: cstring, window_name: cstring, width: i32, height: i32,
    backend: GraphicsBackend = .OPEN_GL,
    debug_mode: bool = false
) -> RenderContext {
    backend := backend
    #partial switch backend {
        case .DIRECTX3D11:
            when (ODIN_OS != .Windows) {
                Util.log(.WARN, "MAGMA_2D_RENDERER_INIT", "DirectX3D11 is Windows-only, defaulting to OpenGL.")
                backend = .OPEN_GL
            }

        case .METAL:
            when (ODIN_OS != .Darwin) {
                Util.log(.WARN, "MAGMA_2D_RENDERER_INIT", "Metal is macOS-only, defaulting to OpenGL.")
                backend = .OPEN_GL
            }
    }

    sdl2.SetHint(sdl2.HINT_AUDIO_DEVICE_APP_NAME, app_name)
    sdl2.SetHint(sdl2.HINT_RENDER_VSYNC, "0" if debug_mode else "1")
    sdl2.SetHint(sdl2.HINT_EVENT_LOGGING, "1" if debug_mode else "0")
    sdl2.SetHint(sdl2.HINT_RENDER_BATCHING, "1")
    if !debug_mode {
        sdl2.LogSetAllPriority(.WARN)
    }


    switch backend {
        case .OPEN_GL:
            sdl2.SetHint(sdl2.HINT_RENDER_DRIVER, "opengl")
            sdl2.SetHint(sdl2.HINT_FRAMEBUFFER_ACCELERATION, "opengl")
        case .DIRECTX3D11:
            sdl2.SetHint(sdl2.HINT_RENDER_DRIVER, "direct3d11")
            sdl2.SetHint(sdl2.HINT_FRAMEBUFFER_ACCELERATION, "direct3d11")
            if (debug_mode) {
                sdl2.SetHint(sdl2.HINT_RENDER_DIRECT3D11_DEBUG, "1")
            }
        case .METAL:
            sdl2.SetHint(sdl2.HINT_RENDER_DRIVER, "metal")
            sdl2.SetHint(sdl2.HINT_FRAMEBUFFER_ACCELERATION, "metal")
        case .SOFTWARE:
            sdl2.SetHint(sdl2.HINT_RENDER_DRIVER, "software")
            sdl2.SetHint(sdl2.HINT_FRAMEBUFFER_ACCELERATION, "software")
    }

    if sdl2.Init(sdl2.INIT_VIDEO | sdl2.INIT_AUDIO) != 0 {
        Util.log(.ERROR, "MAGMA_2D_RENDERER_INIT", sdl2.GetErrorString())
    }


    window_flags: sdl2.WindowFlags = {.SHOWN, .ALLOW_HIGHDPI}
    window := sdl2.CreateWindow(
        window_name,
        sdl2.WINDOWPOS_CENTERED, sdl2.WINDOWPOS_CENTERED,
        width, height,
        window_flags
    )
    if window == nil {
        Util.log(.ERROR, "MAGMA_2D_RENDERER_INIT", "Failed to create window: %s", sdl2.GetErrorString())
        sdl2.Quit()
    }

    renderer_flags: sdl2.RendererFlags
    switch backend {
        case .SOFTWARE:
            renderer_flags = {.SOFTWARE}
        case .DIRECTX3D11, .METAL, .OPEN_GL:
            renderer_flags = {.ACCELERATED}
    }

    renderer := sdl2.CreateRenderer(window, -1, renderer_flags)
    if renderer == nil {
        Util.log(.ERROR, "MAGMA_2D_RENDERER_INIT", "Failed to create renderer: %s", sdl2.GetErrorString())
        sdl2.Quit()
    }

    // Init SDL_image
    image.Init({.JPG, .PNG, .TIF, .WEBP})
    // --- Splash Screen ---
    splash_rw := sdl2.RWFromConstMem(&Types.SplashImage[0], cast(i32)len(Types.SplashImage))
    splash_surface := image.Load_RW(splash_rw, true)
    if splash_surface == nil {
        Util.log(.ERROR, "MAGMA_2D_RENDERER_INIT", "Failed to load splash image: %s", sdl2.GetErrorString())
    } else {
        splash_texture := sdl2.CreateTextureFromSurface(renderer, splash_surface)
        sdl2.FreeSurface(splash_surface)
        
        if splash_texture != nil {
            tex_w, tex_h: i32
            sdl2.QueryTexture(splash_texture, nil, nil, &tex_w, &tex_h)
            win_w, win_h: i32
            sdl2.GetRendererOutputSize(renderer, &win_w, &win_h)
            
            scale := math.min(f32(win_w) / f32(tex_w), f32(win_h) / f32(tex_h))
            dst_w := cast(i32)(f32(tex_w) * scale)
            dst_h := cast(i32)(f32(tex_h) * scale)
            
            dst_rect := sdl2.Rect{
                x = (win_w - dst_w) / 2,
                y = (win_h - dst_h) / 2,
                w = dst_w,
                h = dst_h,
            }
            // Render first splash
            sdl2.RenderClear(renderer)
            sdl2.RenderCopy(renderer, splash_texture, nil, &dst_rect)
            sdl2.RenderPresent(renderer)
            sdl2.Delay(3000)
            sdl2.DestroyTexture(splash_texture)
        } else {
            Util.log(.ERROR, "MAGMA_2D_RENDERER_INIT", "Failed to create splash texture: %s", sdl2.GetErrorString())
        }
    }


    render_texture := sdl2.CreateTexture(renderer, .RGBA8888, .TARGET, width, height)

    return RenderContext {
        Window = window,
        Renderer = renderer,
        RenderSurface = render_texture
    }

}

/*
 * Update Updates the renderer with whatever should be rendered to the screen
 * @param cxt The renderer context for the window you want to update
*/
Update :: proc(ctx: ^RenderContext) {
    sdl2.SetRenderTarget(ctx.Renderer, nil)  // Switch to default window framebuffer

    w: i32 = 0
    h: i32 = 0
    _ = sdl2.GetRendererOutputSize(ctx.Renderer, &w, &h)

    dstRect: sdl2.Rect = {x = 0, y = 0, w = w, h = h}
    _ = sdl2.RenderCopy(ctx.Renderer, ctx.RenderSurface, nil, &dstRect)
    Frames += 1
    Util.log(.DEBUG, "MAGMA_2D_RENDERER_UPDATE", "Frame: %d", Frames)
}


/*
 * SetFullscreen controls if the window in the renderer context is fullscreen or not
 * @param cxt the renderer context of the window you want to toggle fullscreen on
 * @param fullscreen the flag that sets if the window is fullscreen or not
*/
SetFullscreen :: proc(ctx: RenderContext, fullscreen: bool) {
    switch fullscreen {
        case true:
            sdl2.SetWindowFullscreen(ctx.Window, {.FULLSCREEN})
        case false:
            sdl2.SetWindowFullscreen(ctx.Window, {})
    }

}

/*
 * Shutdown cleans up the window and renderer then quits SDL2
 * @param cxt the context to clean up
*/
Shutdown :: proc(ctx: RenderContext) {
    if ctx.Renderer != nil {
        sdl2.DestroyRenderer(ctx.Renderer)
    }
    if ctx.RenderSurface != nil {
        sdl2.DestroyTexture(ctx.RenderSurface)
    }
    if ctx.Window != nil {
        sdl2.DestroyWindow(ctx.Window)
    }
    image.Quit()
    sdl2.Quit()
}

/*
 * FPSLimiter limits the FPS to a specific value
 * @param target_fps the number for the fps you want to limit to
*/
FPSLimiter :: proc(target_fps: u32) {

    frame_delay := 1000 / target_fps

    @static last_time: u32
    last_time = sdl2.GetTicks()
    current_time := sdl2.GetTicks()
    elapsed := current_time - last_time

    if elapsed < frame_delay {
        sdl2.Delay(frame_delay - elapsed)
    }

    last_time = sdl2.GetTicks()
}

/*
 * GetDeltaTime returns the time in seconds between the current frame and the previous frame.
 * It only updates the previous frame time every second call, effectively measuring delta over two frames.
 *
 * @return delta time in seconds (f32)
 */
GetDeltaTime :: proc() -> f32 {
    @static initialized: bool = false
    @static last_time: u32
    @static update_last: bool = false

    if !initialized {
        last_time = sdl2.GetTicks()
        initialized = true
    }

    current_time := sdl2.GetTicks()
    delta := f32(current_time - last_time) / 1000.0

    if update_last {
        last_time = current_time
    }
    update_last = !update_last

    return delta
}

