package main

import "../../2D/Renderer"
import "../../2D/EventSys"
import "../../Types"
import "../../Util"
import "core:fmt"
import "core:mem"


backend: Renderer.GraphicsBackend = .SOFTWARE
main :: proc() {

    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
    
    defer {
        if len(track.allocation_map) > 0 {
            fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
                for _, entry in track.allocation_map {
		fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
		}
	}
	if len(track.bad_free_array) > 0 {
		fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
		for entry in track.bad_free_array {
			fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
		}
	}
	mem.tracking_allocator_destroy(&track)
    }
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
        // Get the Delta time for this frame
        delta_time: f32 = Renderer.GetDeltaTime()

        // Move rectangle based on currently pressed keys
        if keyboard.states[EventSys.KEYS.W] { rect_pos.y -= speed * delta_time }
        if keyboard.states[EventSys.KEYS.S] { rect_pos.y += speed * delta_time }
        if keyboard.states[EventSys.KEYS.A] { rect_pos.x -= speed * delta_time }
        if keyboard.states[EventSys.KEYS.D] { rect_pos.x += speed * delta_time }

        // Render
        // Clear the screen with solid black
        Renderer.ClearScreen(&ctx, {0,0,0,255})
        // Draw the "box"
        Renderer.DrawRect(&ctx, rect_pos, rect_size, {255, 255, 255, 255})
        // Update the renderer to add the "box" we drew
        Renderer.Update(&ctx)
        // Draw the renderer to the screen
        Renderer.PresentScreen(&ctx)

        // Quit if window requested
        if win_state.should_quit {
            running = false
        }

        // Limit to aprox 60 FPS
        Renderer.FPSLimiter(60)

        free_all(context.temp_allocator)
    }

    free(mouse)
    free(keyboard)
    free(win_state)
}
