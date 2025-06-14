package EventSys

import "vendor:sdl2"

WindowState :: struct {
    should_quit:        bool,
    resized:            bool,
    new_width:          i32,
    new_height:         i32,
    minimized:          bool,
    maximized:          bool,
    focus_gained:       bool,
    focus_lost:         bool,
    mouse_entered:      bool,
    mouse_left:         bool,
}

ResetWindowFlags :: proc(state: ^WindowState) {
    state.should_quit        = false
    state.resized            = false
    state.minimized          = false
    state.maximized          = false
    state.focus_gained       = false
    state.focus_lost         = false
    state.mouse_entered      = false
    state.mouse_left         = false
}


HandleWindowEvents :: proc(state: ^WindowState) {
    event: sdl2.Event
    for sdl2.PollEvent(&event) {
        #partial switch event.type {
        case sdl2.EventType.QUIT:
            state.should_quit = true

        case sdl2.EventType.WINDOWEVENT:
            win_event := event.window
            #partial switch win_event.event {
            case sdl2.WindowEventID.RESIZED:
                state.resized = true
                state.new_width = win_event.data1
                state.new_height = win_event.data2

            case sdl2.WindowEventID.MINIMIZED:
                state.minimized = true

            case sdl2.WindowEventID.MAXIMIZED:
                state.maximized = true

            case sdl2.WindowEventID.FOCUS_GAINED:
                state.focus_gained = true

            case sdl2.WindowEventID.FOCUS_LOST:
                state.focus_lost = true

            case sdl2.WindowEventID.ENTER:
                state.mouse_entered = true

            case sdl2.WindowEventID.LEAVE:
                state.mouse_left = true
            }
        }
    }
}
