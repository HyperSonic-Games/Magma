package main

import "../../2D/Renderer"
import "../../2D/EventSys"
import "../../Types"
import "../../Util"

backend: Renderer.GraphicsBackend = .SOFWARE

main :: proc () {
    ctx := Renderer.Init("hello", "hello", 800, 500, backend)
    mouse := new(EventSys.Mouse)
    keyboard := new(EventSys.Keyboard)
    win_state := new(EventSys.WindowState)
    running := true
    for running == true {
        EventSys.HandleEvents(mouse, keyboard, win_state)
        Renderer.Update(&ctx)
        Renderer.PresentScreen(&ctx)
        if win_state.should_quit == true {
            running = false
            continue
        }
    
    }
    free(mouse)
    free(keyboard)
    free(win_state)
}