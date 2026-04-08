package main

import "core:math"
import "../../2D/Renderer"
import "../../2D/EventSys"
import "../../Types"
import "../../Util"
import "../../2D/Kinematics"

import "core:fmt"
import "vendor:sdl2"

backend: Renderer.GraphicsBackend = .SOFTWARE

PLAYER_ID :: Kinematics.ObjectID(1)
FLOOR_ID  :: Kinematics.ObjectID(2)

main :: proc() {
    ctx := Renderer.Init("hello", "hello", 800, 500, backend)

    mouse := new(EventSys.Mouse)
    keyboard := new(EventSys.Keyboard)
    win_state := new(EventSys.WindowState)

    running := true

    // -----------------------------
    // Kinematics world setup
    // -----------------------------
    world := new(Kinematics.World)

    player := new(Kinematics.Object)
    player.pos = {100, 100}
    player.width = 50
    player.height = 50
    player.rot = 0
    player.is_static = false

    floor := new(Kinematics.Object)
    floor.pos = {0, 400}
    floor.width = 800
    floor.height = 100
    floor.rot = 0
    floor.is_static = true

    world.objects[PLAYER_ID] = player
    world.objects[FLOOR_ID] = floor

    Kinematics.StartSolver(world)

    speed: f32 = 200.0

    for running {
        EventSys.HandleEvents(mouse, keyboard, win_state)

        dt := Renderer.GetDeltaTime()
        if dt < 0.001 {
            dt = 0.001
        }

        // -----------------------------
        // Player input -> Kinematics move
        // -----------------------------
        move := Types.Vector2f{0, 0}

        if keyboard.states[EventSys.KEYS.W] { move.y -= 1 }
        if keyboard.states[EventSys.KEYS.S] { move.y += 1 }
        if keyboard.states[EventSys.KEYS.A] { move.x -= 1 }
        if keyboard.states[EventSys.KEYS.D] { move.x += 1 }

        if keyboard.states[EventSys.KEYS.Q] {
            player.rot -= math.to_radians(cast(f32)1)
        }
        if keyboard.states[EventSys.KEYS.E] {
            player.rot += math.to_radians(cast(f32)1)
        }

        move *= speed * dt

        Kinematics.MoveObject(world, PLAYER_ID, move)

        // -----------------------------
        // Render
        // -----------------------------
        Renderer.ClearScreen(&ctx, {0, 0, 0, 255})

        Renderer.DrawRect(
            &ctx,
            player.pos,
            {player.width, player.height},
            {255, 255, 255, 255},
            rot = math.to_degrees(player.rot)
        )

        Renderer.DrawRect(
            &ctx,
            floor.pos,
            {floor.width, floor.height},
            {120, 120, 120, 255},
        )

        Renderer.Update(&ctx)
        Renderer.PresentScreen(&ctx)

        if win_state.should_quit {
            running = false
        }

        other_id, hit := Kinematics.IsCollidingWith(world, PLAYER_ID)

        if hit {
            fmt.println("Hit object:", other_id)
        }

        free_all(context.temp_allocator)
    }

    Kinematics.StopSolver(world)

    free(mouse)
    free(keyboard)
    free(win_state)
}