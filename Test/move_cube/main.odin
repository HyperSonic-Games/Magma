package main

import "../../2D/Renderer"
import "../../2D/EventSys"
import "../../Types"
import "core:time"

CellSize :: 20

main :: proc() {
    backend: Renderer.GraphicsBackend = .OPEN_GL
    mouse: EventSys.Mouse
    winstate: EventSys.WindowState
    keyboard: EventSys.Keyboard
    running: bool = true

    ctx: Renderer.RenderContext = Renderer.Init("Move Square", "Move Square", 800, 500, backend, true)
    defer Renderer.Shutdown(ctx)

    pos: Types.Vector2 = Types.Vector2{} // default zero vector

    for running {
        EventSys.HandleEvents(&mouse, &keyboard, &winstate)
        if winstate.should_quit {
            running = false
            break
        }

        if keyboard.key == .W {
            pos = Types.Vector2SetY(pos, Types.Vector2GetY(pos) - CellSize)
        }
        if keyboard.key == .S {
            pos = Types.Vector2SetY(pos, Types.Vector2GetY(pos) + CellSize)
        }
        if keyboard.key == .A {
            pos = Types.Vector2SetX(pos, Types.Vector2GetX(pos) - CellSize)
        }
        if keyboard.key == .D {
            pos = Types.Vector2SetX(pos, Types.Vector2GetX(pos) + CellSize)
        }
        keyboard.key = .NONE

        // Clamp position to window bounds
        x := Types.Vector2GetX(pos)
        y := Types.Vector2GetY(pos)
        if x < 0 { pos = Types.Vector2SetX(pos, 0) }
        if y < 0 { pos = Types.Vector2SetY(pos, 0) }
        if x >= 800 { pos = Types.Vector2SetX(pos, 800 - CellSize) }
        if y >= 500 { pos = Types.Vector2SetY(pos, 500 - CellSize) }

        Renderer.ClearScreen(&ctx, Types.Color{0, 0, 0, 255})
        Renderer.DrawRect(&ctx, auto_cast Types.Vector2GetX(pos), auto_cast Types.Vector2GetY(pos), CellSize, CellSize, Types.Color{0, 255, 0, 255})
        Renderer.Update(&ctx)
        Renderer.PresentScreen(&ctx)

        time.sleep(time.Millisecond * 16) // ~60 FPS
    }
}
