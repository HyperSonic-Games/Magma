package main

import "../../2D/Renderer"
import "../../2D/EventSys"
import "../../Types"
import "../../Util"
import "core:fmt"
import "vendor:sdl2"

backend: Renderer.GraphicsBackend = .SOFTWARE

main :: proc() {
    ctx := Renderer.Init("hello", "hello", 800, 500, backend)
    mouse := new(EventSys.Mouse)
    keyboard := new(EventSys.Keyboard)
    win_state := new(EventSys.WindowState)
    running := true

    // Rectangle state
    rect_pos: Types.Vector2f = { 52, 50 }
    rect_size: Types.Vector2f = { 100, 100 }
    speed: f32 = 100.0 // pixels per second

    for running {
        // Update keyboard & mouse state
        EventSys.HandleEvents(mouse, keyboard, win_state)
        delta_time: f32 = Renderer.GetDeltaTime()

        // Clamp delta_time if needed
        if delta_time < 0.001 {
            delta_time = 0.001
        }

        // Move rectangle based on currently pressed keys
        if keyboard.states[EventSys.KEYS.W] { rect_pos.y -= speed * delta_time }
        if keyboard.states[EventSys.KEYS.S] { rect_pos.y += speed * delta_time }
        if keyboard.states[EventSys.KEYS.A] { rect_pos.x -= speed * delta_time }
        if keyboard.states[EventSys.KEYS.D] { rect_pos.x += speed * delta_time }

        // Render
        Renderer.ClearScreen(&ctx, {0,0,0,255})
        Renderer.DrawRect(&ctx, rect_pos, rect_size, {255, 255, 255, 255})
        Renderer.Update(&ctx)
        Renderer.PresentScreen(&ctx)

        // Quit if window requested
        if win_state.should_quit {
            running = false
        }

        free_all(context.temp_allocator)
    }

    free(mouse)
    free(keyboard)
    free(win_state)
}
