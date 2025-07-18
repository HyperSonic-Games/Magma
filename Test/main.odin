package main

import "../2D/Renderer"
import "../2D/EventSys"
import "../Types"
import "../Util"

main :: proc() {
    backend: Renderer.GraphicsBackend = .OPEN_GL
    mouse: EventSys.Mouse
    winstate: EventSys.WindowState
    keyboard: EventSys.Keyboard
    running: bool = true


    ctx: Renderer.RenderContext = Renderer.Init("Magma Engine Test App", "Magma Engine Test App", 800, 500, backend, true)
    
    rect_color := Types.Color{25, 230, 12, 0}
    Renderer.DrawRect(&ctx, 0, 0, 100, 100, rect_color)

    defer Renderer.Shutdown(ctx)
    Util.ReadBase32File()



    for running {
        Renderer.FPSLimiter(60)

        EventSys.HandleEvents(&mouse, &keyboard, &winstate)

        if winstate.should_quit {
            running = false
            break
        }


        Renderer.Update(&ctx)
        Renderer.PresentScreen(&ctx)
    }

}
