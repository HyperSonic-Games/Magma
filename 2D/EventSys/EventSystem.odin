package EventSys

import "core:c"
import "../../Types"
import "../../Util"
import "core:simd"
import "vendor:sdl2"

// ---------------------------
// Input Enums
// ---------------------------

MOD_KEYS :: enum {
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

MouseButton :: enum {
    LEFT,
    RIGHT,
    MIDDLE,
    X1,
    X2,
}

// ---------------------------
// Input State
// ---------------------------

Mouse :: struct {
    position: Types.Vector2,
    buttons:  bit_set[MouseButton], // held buttons
    pressed:  bit_set[MouseButton], // pressed this frame
    released: bit_set[MouseButton], // released this frame
}

Keyboard :: struct {
    mods:     bit_set[MOD_KEYS], // held modifiers
    keys:     bit_set[KEYS],     // held keys
    pressed:  bit_set[KEYS],     // pressed this frame
    released: bit_set[KEYS],     // released this frame
}

// ---------------------------
// Window State (transient signals)
// ---------------------------

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

// ---------------------------
// Helpers
// ---------------------------

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
ConvertSDLModToMODKEYS :: proc(mod: sdl2.Keymod) -> bit_set[MOD_KEYS] {
    using sdl2
    mods: bit_set[MOD_KEYS] = {}
    if (mod & KMOD_LSHIFT) != {} {mods += {.L_SHIFT}}
    if (mod & KMOD_RSHIFT) != {} {mods += {.R_SHIFT}}
    if (mod & KMOD_LCTRL)  != {} {mods += {.L_CTRL}}
    if (mod & KMOD_RCTRL)  != {} {mods += {.R_CTRL}}
    if (mod & KMOD_LALT)   != {} {mods += {.L_ALT}}
    if (mod & KMOD_RALT)   != {} {mods += {.R_ALT}}
    if (mod & KMOD_GUI)    != {} {mods += {.WIN}}
    return mods
}

// ---------------------------
// Event Handling
// ---------------------------

HandleEvents :: proc(mouse: ^Mouse, keyboard: ^Keyboard, win: ^WindowState) {
    ResetWindowFlags(win)
    mouse.pressed  = {}
    mouse.released = {}
    keyboard.pressed  = {}
    keyboard.released = {}

    event: sdl2.Event
    for sdl2.PollEvent(&event) != false {
        #partial switch event.type {
        case sdl2.EventType.QUIT:
            win.should_quit = true

        case sdl2.EventType.MOUSEMOTION:
            motion := event.motion
            mouse.position = simd.replace(mouse.position, 0, cast(i64)motion.x)
            mouse.position = simd.replace(mouse.position, 1, cast(i64)motion.y)

        case sdl2.EventType.MOUSEBUTTONDOWN:
            btn := event.button
            switch btn.button {
            case sdl2.BUTTON_LEFT:   mouse.buttons += {.LEFT};   mouse.pressed += {.LEFT}
            case sdl2.BUTTON_RIGHT:  mouse.buttons += {.RIGHT};  mouse.pressed += {.RIGHT}
            case sdl2.BUTTON_MIDDLE: mouse.buttons += {.MIDDLE}; mouse.pressed += {.MIDDLE}
            case sdl2.BUTTON_X1:     mouse.buttons += {.X1};     mouse.pressed += {.X1}
            case sdl2.BUTTON_X2:     mouse.buttons += {.X2};     mouse.pressed += {.X2}
            }

        case sdl2.EventType.MOUSEBUTTONUP:
            btn := event.button
            switch btn.button {
            case sdl2.BUTTON_LEFT:   mouse.buttons -= {.LEFT};   mouse.released += {.LEFT}
            case sdl2.BUTTON_RIGHT:  mouse.buttons -= {.RIGHT};  mouse.released += {.RIGHT}
            case sdl2.BUTTON_MIDDLE: mouse.buttons -= {.MIDDLE}; mouse.released += {.MIDDLE}
            case sdl2.BUTTON_X1:     mouse.buttons -= {.X1};     mouse.released += {.X1}
            case sdl2.BUTTON_X2:     mouse.buttons -= {.X2};     mouse.released += {.X2}
            }

        case sdl2.EventType.KEYDOWN:
            keysym := event.key.keysym
            k := ConvertSDLKeycodeToKEYS(keysym.sym)
            if k != KEYS.NONE {
                keyboard.keys    += {k}
                keyboard.pressed += {k}
            }
            keyboard.mods = ConvertSDLModToMODKEYS(keysym.mod)

        case sdl2.EventType.KEYUP:
            keysym := event.key.keysym
            k := ConvertSDLKeycodeToKEYS(keysym.sym)
            if k != KEYS.NONE {
                keyboard.keys     -= {k}
                keyboard.released += {k}
            }
            keyboard.mods = ConvertSDLModToMODKEYS(keysym.mod)

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

                case: {}
            }

        case: {}
        }
    }
}
