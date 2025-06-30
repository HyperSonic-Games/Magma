package main

import "core:fmt"
import "../2D/Renderer"
import "../2D/EventSys"
import "../Types"
import "../Util"



// Test file

main :: proc() {
    
    backend: Renderer.GraphicsBackend = .OPEN_GL
    mouse: EventSys.Mouse
    winstate: EventSys.WindowState

    running: bool = true

    ctx: Renderer.RenderContext = Renderer.Init("Magma Engine Test App", "Magma Engine Test App", 800, 500, backend, false)
    
    rect_color := Types.Color{25, 230, 12, 0}
    Renderer.DrawRect(&ctx, 0, 0, 100, 100, rect_color)

    defer Renderer.Shutdown(ctx)

    for (running) {
        EventSys.ResetWindowFlags(&winstate)
        Renderer.FPSLimiter(60)
        EventSys.HandleWindowEvents(&winstate)

        if (winstate.should_quit) {
            running = false
        }

        EventSys.HandleMouseInput(&mouse)
        Renderer.Update(&ctx)
        Renderer.PresentScreen(&ctx)
    }
}