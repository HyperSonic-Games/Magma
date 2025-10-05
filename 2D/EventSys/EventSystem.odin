package EventSys

import "core:c"
import "../../Types"
import "../../Util"
import "core:simd"
import "vendor:sdl2"

MOD_KEYS :: enum {
    NONE,
    L_SHIFT, R_SHIFT,
    L_CTRL,  R_CTRL,
    L_ALT,   R_ALT,
    WIN,
}

KEYS :: enum {
    NONE,
    A, B, C, D, E, F, G, H, I, J, K, L, M,
    N, O, P, Q, R, S, T, U, V, W, X, Y, Z,
    ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, ZERO,
    ENTER, ESCAPE, BACKSPACE, TAB, SPACE,
}

Mouse :: struct {
    position: Types.Vector2,
    RClick: bool,
    LClick: bool,
}

Keyboard :: struct {
    mod: MOD_KEYS,
    key: KEYS,
}

WindowState :: struct {
    should_quit:    bool,
    resized:        bool,
    new_width:      i32,
    new_height:     i32,
    minimized:      bool,
    maximized:      bool,
    focus_gained:   bool,
    focus_lost:     bool,
    mouse_entered:  bool,
    mouse_left:     bool,
}

/*
 * ResetWindowFlags sets all the window state flags to a known state (should be called after game logic in the main loop)
 *
 * @param state a pointer to a stucture that holds the window state data
*/
ResetWindowFlags :: proc(state: ^WindowState) {
    state.should_quit   = false
    state.resized       = false
    state.minimized     = false
    state.maximized     = false
    state.focus_gained  = false
    state.focus_lost    = false
    state.mouse_entered = false
    state.mouse_left    = false
}

@private
ConvertSDLKeycodeToKEYS :: proc(sym: sdl2.Keycode) -> KEYS {
    #partial switch sym {
        case sdl2.Keycode.A: return KEYS.A
        case sdl2.Keycode.B: return KEYS.B
        case sdl2.Keycode.C: return KEYS.C
        case sdl2.Keycode.D: return KEYS.D
        case sdl2.Keycode.E: return KEYS.E
        case sdl2.Keycode.F: return KEYS.F
        case sdl2.Keycode.G: return KEYS.G
        case sdl2.Keycode.H: return KEYS.H
        case sdl2.Keycode.I: return KEYS.I
        case sdl2.Keycode.J: return KEYS.J
        case sdl2.Keycode.K: return KEYS.K
        case sdl2.Keycode.L: return KEYS.L
        case sdl2.Keycode.M: return KEYS.M
        case sdl2.Keycode.N: return KEYS.N
        case sdl2.Keycode.O: return KEYS.O
        case sdl2.Keycode.P: return KEYS.P
        case sdl2.Keycode.Q: return KEYS.Q
        case sdl2.Keycode.R: return KEYS.R
        case sdl2.Keycode.S: return KEYS.S
        case sdl2.Keycode.T: return KEYS.T
        case sdl2.Keycode.U: return KEYS.U
        case sdl2.Keycode.V: return KEYS.V
        case sdl2.Keycode.W: return KEYS.W
        case sdl2.Keycode.X: return KEYS.X
        case sdl2.Keycode.Y: return KEYS.Y
        case sdl2.Keycode.Z: return KEYS.Z
        case sdl2.Keycode.KP_1: return KEYS.ONE
        case sdl2.Keycode.KP_2: return KEYS.TWO
        case sdl2.Keycode.KP_3: return KEYS.THREE
        case sdl2.Keycode.KP_4: return KEYS.FOUR
        case sdl2.Keycode.KP_5: return KEYS.FIVE
        case sdl2.Keycode.KP_6: return KEYS.SIX
        case sdl2.Keycode.KP_7: return KEYS.SEVEN
        case sdl2.Keycode.KP_8: return KEYS.EIGHT
        case sdl2.Keycode.KP_9: return KEYS.NINE
        case sdl2.Keycode.KP_0: return KEYS.ZERO
        case sdl2.Keycode.RETURN: return KEYS.ENTER
        case sdl2.Keycode.ESCAPE: return KEYS.ESCAPE
        case sdl2.Keycode.BACKSPACE: return KEYS.BACKSPACE
        case sdl2.Keycode.TAB: return KEYS.TAB
        case sdl2.Keycode.SPACE: return KEYS.SPACE
        case: return KEYS.NONE
    }
}

@private
ConvertSDLModToMODKEYS :: proc(mod: sdl2.Keymod) -> MOD_KEYS {
    using sdl2
    if (mod & KMOD_LSHIFT) != {} {return MOD_KEYS.L_SHIFT}
    if (mod & KMOD_RSHIFT) != {} {return MOD_KEYS.R_SHIFT}
    if (mod & KMOD_LCTRL)  != {} {return MOD_KEYS.L_CTRL}
    if (mod & KMOD_RCTRL)  != {} {return MOD_KEYS.R_CTRL}
    if (mod & KMOD_LALT)   != {} {return MOD_KEYS.L_ALT}
    if (mod & KMOD_RALT)   != {} {return MOD_KEYS.R_ALT}
    if (mod & KMOD_GUI)    != {} {return MOD_KEYS.WIN}
    else {return MOD_KEYS.NONE}
}

/*
 * HandleEvents When called updates all of the event structures passed to it
 *
 * @param mouse a pointer to a stucture that holds mouse data
 * @param keyboard a pointer to a structure that contains all ot the keys and mod keys being pressed
 * @param win a pointer to a structure that holds general window state (fullscreen, quit state, ect)
*/
HandleEvents :: proc(mouse: ^Mouse, keyboard: ^Keyboard, win: ^WindowState) {
    ResetWindowFlags(win)

    event: sdl2.Event
    for sdl2.PollEvent(&event) != false {
        #partial switch event.type {
        case sdl2.EventType.QUIT:
            win.should_quit = true

        case sdl2.EventType.MOUSEMOTION:
            motion := event.motion
            mouse.position[0] = motion.x
            mouse.position[1] = motion.y

        case sdl2.EventType.MOUSEBUTTONDOWN:
            btn := event.button
            if btn.button == sdl2.BUTTON_LEFT {
                mouse.LClick = true
            } else if btn.button == sdl2.BUTTON_RIGHT {
                mouse.RClick = true
            }

        case sdl2.EventType.MOUSEBUTTONUP:
            btn := event.button
            if btn.button == sdl2.BUTTON_LEFT {
                mouse.LClick = false
            } else if btn.button == sdl2.BUTTON_RIGHT {
                mouse.RClick = false
            }

        case sdl2.EventType.KEYDOWN:
            keysym := event.key.keysym
            keyboard.key = ConvertSDLKeycodeToKEYS(keysym.sym)
            keyboard.mod = ConvertSDLModToMODKEYS(keysym.mod)

        case sdl2.EventType.KEYUP:
            keyboard.key = KEYS.NONE
            keyboard.mod = ConvertSDLModToMODKEYS(event.key.keysym.mod)

        case sdl2.EventType.WINDOWEVENT:
            win_event := event.window
            #partial switch win_event.event {
                case sdl2.WindowEventID.RESIZED:
                    win.resized    = true
                    win.new_width  = win_event.data1
                    win.new_height = win_event.data2

                case sdl2.WindowEventID.MINIMIZED:    win.minimized     = true
                case sdl2.WindowEventID.MAXIMIZED:    win.maximized     = true
                case sdl2.WindowEventID.FOCUS_GAINED: win.focus_gained  = true
                case sdl2.WindowEventID.FOCUS_LOST:   win.focus_lost    = true
                case sdl2.WindowEventID.ENTER:        win.mouse_entered = true
                case sdl2.WindowEventID.LEAVE:        win.mouse_left    = true

                case: {} // ignore unhandled window events
            }

        case: {} // ignore all other unknown events safely
        }
    }
}