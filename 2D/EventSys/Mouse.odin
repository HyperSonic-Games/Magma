package EventSys

import "../../Types"
import "../../Util"
import "../Renderer"
import "core:simd"

import "vendor:sdl2"

Mouse :: struct {
    position: Types.Vector2, // SIMD type: f64x2
    RClick: bool,
    LClick: bool,
}

HandleMouseInput :: proc(mouse: ^Mouse) {
    MouseEvent: sdl2.Event
    for sdl2.PollEvent(&MouseEvent) {
        #partial switch MouseEvent.type {
        case sdl2.EventType.MOUSEMOTION:
            motion := MouseEvent.motion
            mouse.position = simd.replace(mouse.position, 0, cast(i64)motion.x)
            mouse.position = simd.replace(mouse.position, 1, cast(i64)motion.x)

        case sdl2.EventType.MOUSEBUTTONDOWN:
            btn := MouseEvent.button
            if btn.button == sdl2.BUTTON_LEFT {
                mouse.LClick = true
            } else if btn.button == sdl2.BUTTON_RIGHT {
                mouse.RClick = true
            }

        case sdl2.EventType.MOUSEBUTTONUP:
            btn := MouseEvent.button
            if btn.button == sdl2.BUTTON_LEFT {
                mouse.LClick = false
            } else if btn.button == sdl2.BUTTON_RIGHT {
                mouse.RClick = false
            }
        }
    }
}
