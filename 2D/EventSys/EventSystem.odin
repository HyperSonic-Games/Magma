#+feature using-stmt
package EventSys

import "../../Types"
import "../Renderer"
import "core:math"
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
    MAX_KEYS  // keep this as the count of keys
}

Mouse :: struct {
	position: Types.Vector2f,
	RClick: bool,
	LClick: bool,
	prev_RClick: bool,
	prev_LClick: bool,
}

Keyboard :: struct {
    mod: MOD_KEYS,
    states: [KEYS.MAX_KEYS]bool, // true if key is currently held
}

WindowState :: struct {
    should_quit: bool,
    minimized: bool,
    maximized: bool,
    focus_gained: bool,
    focus_lost: bool,
    mouse_entered: bool,
    mouse_left: bool,
}

/*
resets all transient window flags in preparation
for the next frame. This should be called at the start of every frame.
@param state Pointer to the WindowState struct to reset
*/
ResetWindowFlags :: proc(state: ^WindowState) {
    state.should_quit = false
    state.minimized = false
    state.maximized = false
    state.focus_gained = false
    state.focus_lost = false
    state.mouse_entered = false
    state.mouse_left = false
}

/*
converts an SDL2 keycode to the engine's KEYS enum.
Returns KEYS.NONE if no match is found.
NOTE: This is internal and only documented for internal use
@param sym SDL2 keycode
@return Corresponding KEYS enum value
*/
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

/*
converts SDL2 modifier flags into the engine's MOD_KEYS enum.
Only returns one modifier at a time. Returns MOD_KEYS.NONE if no relevant modifier is active.
NOTE: This is internal and only documented for internal use
@param mod SDL2 modifier bitfield
@return Corresponding MOD_KEYS value
*/
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

@(private)
GetLogicalMousePos :: proc(ctx: ^Renderer.RenderContext, physical_mx, physical_my: i32) -> Types.Vector2f {
    win_w, win_h: i32
    sdl2.GetRendererOutputSize(ctx.Renderer, &win_w, &win_h)
    
    tex_w, tex_h: i32
    sdl2.QueryTexture(ctx.RenderSurface, nil, nil, &tex_w, &tex_h)

    scale := math.min(
        f32(win_w) / f32(tex_w),
        f32(win_h) / f32(tex_h),
    )
    
    dst_w := f32(tex_w) * scale
    dst_h := f32(tex_h) * scale
    
    // Find the offset padding bars (letterbox/pillarbox)
    offset_x := (f32(win_w) - dst_w) * 0.5
    offset_y := (f32(win_h) - dst_h) * 0.5
    
    // Reverse the scaling math to get the true position on your canvas
    logical_x := (f32(physical_mx) - offset_x) / scale
    logical_y := (f32(physical_my) - offset_y) / scale
    
    return Types.Vector2f{logical_x, logical_y}
}


/*
polls SDL2 for all events and updates the engine's input and window state.
This function should be called once per frame.
@param mouse pointer to the Mouse struct to update
@param keyboard pointer to the Keyboard struct to update
@param win pointer to the WindowState struct to update
*/
HandleEvents :: proc(ctx: ^Renderer.RenderContext, mouse: ^Mouse, keyboard: ^Keyboard, win: ^WindowState) {
    mouse.prev_LClick = mouse.LClick
    mouse.prev_RClick = mouse.RClick
    // FIX: Always query and translate the absolute mouse state at the start of the frame.
    // This catches clicks safely even if the cursor hasn't moved an inch.
    raw_mx, raw_my: i32
    sdl2.GetMouseState(&raw_mx, &raw_my)
    mouse.position = GetLogicalMousePos(ctx, raw_mx, raw_my)

    event: sdl2.Event
    for sdl2.PollEvent(&event) != false {
        #partial switch event.type {
            case sdl2.EventType.QUIT:
                win.should_quit = true

            case sdl2.EventType.MOUSEBUTTONDOWN:
                btn := event.button
                if btn.button == sdl2.BUTTON_LEFT { mouse.LClick = true }
                if btn.button == sdl2.BUTTON_RIGHT { mouse.RClick = true }

            case sdl2.EventType.MOUSEBUTTONUP:
                btn := event.button
                if btn.button == sdl2.BUTTON_LEFT { mouse.LClick = false }
                if btn.button == sdl2.BUTTON_RIGHT { mouse.RClick = false }

            case sdl2.EventType.KEYDOWN:
                k := ConvertSDLKeycodeToKEYS(event.key.keysym.sym)
                if k != KEYS.NONE { keyboard.states[k] = true }
                keyboard.mod = ConvertSDLModToMODKEYS(event.key.keysym.mod)

            case sdl2.EventType.KEYUP:
                k := ConvertSDLKeycodeToKEYS(event.key.keysym.sym)
                if k != KEYS.NONE { keyboard.states[k] = false }
                keyboard.mod = ConvertSDLModToMODKEYS(event.key.keysym.mod)

            case sdl2.EventType.WINDOWEVENT:
                we := event.window
                #partial switch we.event {
                    case sdl2.WindowEventID.MINIMIZED: win.minimized = true
                    case sdl2.WindowEventID.MAXIMIZED: win.maximized = true
                    case sdl2.WindowEventID.FOCUS_GAINED: win.focus_gained  = true
                    case sdl2.WindowEventID.FOCUS_LOST: win.focus_lost = true
                    case sdl2.WindowEventID.ENTER: win.mouse_entered = true
                    case sdl2.WindowEventID.LEAVE: win.mouse_left = true
                    case: {}
                }

            case: {}
        }
    }
}
