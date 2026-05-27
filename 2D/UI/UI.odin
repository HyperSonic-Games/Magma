package UI

import "core:strings"
import "vendor:sdl2"
import "../../Types"
import "../Renderer"
import "../EventSys"

MessageBoxType :: enum u32 {
	ERROR = 4,
	WARN  = 5,
	INFO  = 6,
}

UIContext :: struct {
	renderer: ^Renderer.RenderContext,
    mouse_input: ^EventSys.Mouse,
}

/*
creates a new UIContext to use for ui state
@param renderer a pointer to the renderer's RenderContext you want to render to
@param mouse_data a pointer to the mouse data returned by the event system every frame
@return a pointer to the new UIContext
*/
CreateUIContext :: proc(renderer: ^Renderer.RenderContext, mouse_data: ^EventSys.Mouse) -> ^UIContext {
    ctx := new(UIContext)

    ctx.renderer = renderer
    ctx.mouse_input = mouse_data
    return ctx
}

/*
deletes a UIContext
@param ctx a pointer to the UIContext you want to delete
*/
DestroyUIContext :: proc(ctx: ^UIContext) {
    free(ctx)
}

@(private)
PointInRect :: proc(p, pos, size: Types.Vector2f) -> bool {
	return p.x >= pos.x &&
		p.y >= pos.y &&
		p.x <= pos.x+size.x &&
		p.y <= pos.y+size.y
}

/*
renders a button to the renderer in ctx
@param cxt a pointer to the UIContext to use for state and rendering
@param pos the position on the screen to render the button
@param size the size of the button
@param color the color of the button
@param pressed_color the color of the button when pressed
@param r_click wether to respond to a right click (true) or a left click (false)
@return a bool indicating if the button was pressed or not
*/
Button :: proc(
	ctx: ^UIContext,
	pos, size: Types.Vector2f,
	color, pressed_color: Types.Color,
	r_click: bool = false,
) -> bool {

	p := Types.Vector2f{
		f32(ctx.mouse_input.position[0]),
		f32(ctx.mouse_input.position[1]),
	}

	hover := PointInRect(p, pos, size)

	pressed :=
		hover &&
		((!r_click && ctx.mouse_input.LClick) ||
		 (r_click && ctx.mouse_input.RClick))

	clicked :=
	hover &&
    ((!r_click &&
		ctx.mouse_input.LClick &&
		!ctx.mouse_input.prev_LClick) ||

	(r_click &&
		ctx.mouse_input.RClick &&
		!ctx.mouse_input.prev_RClick))
	draw := color
	if pressed {
		draw = pressed_color
	}

	Renderer.DrawRect(ctx.renderer, pos, size, draw, true, 0.0)

	return clicked
}
/*
renders a check box to the renderer in ctx
@param ctx a pointer to the UIContext to use for state and rendering
@param pos the position on the screen to render the check box
@param size the size of the hitbox for the checkbox
@param value a pointer to a bool used to store the current state of the checkbox over time
@param check_texture the texture to display when the check box is checked
@param uncheck_texture the texture to display when the check box is unchecked
@return a bool representing the state of the check box this current frame
*/
CheckBox :: proc(
	ctx: ^UIContext,
	pos, size: Types.Vector2f,
	value: ^bool,
	check_texture, uncheck_texture: ^Renderer.Texture,
) -> bool {

	p := Types.Vector2f{
		f32(ctx.mouse_input.position[0]),
		f32(ctx.mouse_input.position[1]),
	}

	hover := PointInRect(p, pos, size)

	clicked :=
		hover &&
		ctx.mouse_input.LClick &&
		!ctx.mouse_input.prev_LClick

	if clicked {
		value^ = !value^
	}

	tex := uncheck_texture
	if value^ {
		tex = check_texture
	}

	Renderer.DrawTexture(ctx.renderer, tex, pos, 0.0)

	return value^
}
/*
renders a slider that uses an unsigned integer for the value
@param ctx a pointer to the UIContext to use for state and rendering
@param pos the position on the screen to render the slider
@param size the size of the slider (this is the bar size as the slide size is calculated from this)
@param value a pointer to a u64 used to store the current state of the checkbox over time
@param min_max an array of two values the first value is the minumum value for the slider and the second value is the maximum value of the slider
@param step_size this is the value that the value steps by when the slider is moved
@param bar_color the color of the bar that the slider is atatched to
@param slide_color the color of the slider
@return a u64 representing the state of the slider this current frame
*/
UnsignedIntegerSlider :: proc(
	ctx: ^UIContext,
	pos, size: Types.Vector2f,
	value: ^u64,
	min_max: [2]u64,
	step_size: u64,
	bar_color: Types.Color,
	slide_color: Types.Color,
) -> u64 {

	p := Types.Vector2f{
		f32(ctx.mouse_input.position[0]),
		f32(ctx.mouse_input.position[1]),
	}

	hover := PointInRect(p, pos, size)

	if hover && ctx.mouse_input.LClick {

		t := (p.x - pos.x) / size.x
		if t < 0 do t = 0
		if t > 1 do t = 1

		range := f32(min_max[1] - min_max[0])
		new_value := min_max[0] + u64(range * t)

		if step_size > 0 {
			new_value = (new_value / step_size) * step_size
            new_value = clamp(new_value, min_max[0], min_max[1])
		}

		value^ = new_value
	}

	Renderer.DrawRect(ctx.renderer, pos, size, bar_color, true, 0.0)

	range := f32(min_max[1] - min_max[0])
	if range <= 0 {
		return value^
	}

	t := (f32(value^) - f32(min_max[0])) / range
	if t < 0 do t = 0
	if t > 1 do t = 1

	handle_size := Types.Vector2f{
		8,
        size.y,
	}

	handle_pos := Types.Vector2f{
		pos.x + t * size.x - handle_size.x * 0.5,
		pos.y,
	}

	Renderer.DrawRect(ctx.renderer, handle_pos, handle_size, slide_color, true, 0.0)

	return value^
}

/*
renders a slider that uses an signed integer for the value
@param ctx a pointer to the UIContext to use for state and rendering
@param pos the position on the screen to render the slider
@param size the size of the slider (this is the bar size as the slide size is calculated from this)
@param value a pointer to a i64 used to store the current state of the checkbox over time
@param min_max an array of two values the first value is the minumum value for the slider and the second value is the maximum value of the slider
@param step_size this is the value that the value steps by when the slider is moved
@param bar_color the color of the bar that the slider is atatched to
@param slide_color the color of the slider
@return a i64 representing the state of the slider this current frame
*/
SignedIntegerSlider :: proc(
	ctx: ^UIContext,
	pos, size: Types.Vector2f,
	value: ^i64,
	min_max: [2]i64,
	step_size: i64,
	bar_color: Types.Color,
	slide_color: Types.Color,
) -> i64 {

	p := Types.Vector2f{
		f32(ctx.mouse_input.position[0]),
		f32(ctx.mouse_input.position[1]),
	}

	hover := PointInRect(p, pos, size)

	if hover && ctx.mouse_input.LClick {

		t := (p.x - pos.x) / size.x
		if t < 0 do t = 0
		if t > 1 do t = 1

		range := f32(min_max[1] - min_max[0])
		new_value := i64(f32(min_max[0]) + range * t)

		if step_size != 0 {
			new_value = (new_value / step_size) * step_size
            new_value = clamp(new_value, min_max[0], min_max[1])
		}

		value^ = new_value
	}

	Renderer.DrawRect(ctx.renderer, pos, size, bar_color, true, 0.0)

	range := f32(min_max[1] - min_max[0])
	if range <= 0 {
		return value^
	}

	t := (f32(value^) - f32(min_max[0])) / range
	if t < 0 do t = 0
	if t > 1 do t = 1

	handle_size := Types.Vector2f{
		8,
		size.y,
	}

	handle_pos := Types.Vector2f{
		pos.x + t * size.x - handle_size.x * 0.5,
		pos.y,
	}

	Renderer.DrawRect(ctx.renderer, handle_pos, handle_size, slide_color, true, 0.0)

	return value^
}

/*
renders a slider that uses a float for the value
@param ctx a pointer to the UIContext to use for state and rendering
@param pos the position on the screen to render the slider
@param size the size of the slider (this is the bar size as the slide size is calculated from this)
@param value a pointer to an f32 used to store the current state of the checkbox over time
@param min_max an array of two values the first value is the minumum value for the slider and the second value is the maximum value of the slider
@param step_size this is the value that the sliders value steps by when the slider is moved
@param bar_color the color of the bar that the slider is atatched to
@param slide_color the color of the slider
@return an f32 representing the state of the slider this current frame
*/
FloatSlider :: proc(
	ctx: ^UIContext,
	pos, size: Types.Vector2f,
	value: ^f32,
	min_max: [2]f32,
	step_size: f32,
	bar_color: Types.Color,
	slide_color: Types.Color,
) -> f32 {

	p := Types.Vector2f{
		f32(ctx.mouse_input.position[0]),
		f32(ctx.mouse_input.position[1]),
	}

	hover := PointInRect(p, pos, size)

	if hover && ctx.mouse_input.LClick {

		t := (p.x - pos.x) / size.x
		if t < 0 do t = 0
		if t > 1 do t = 1

		new_value := min_max[0] + (min_max[1] - min_max[0]) * t

		if step_size > 0 {
			new_value = f32(i32(new_value / step_size)) * step_size
            new_value = clamp(new_value, min_max[0], min_max[1])
		}

		value^ = new_value
	}

	Renderer.DrawRect(ctx.renderer, pos, size, bar_color, true, 0.0)

	range := min_max[1] - min_max[0]
	if range == 0 {
		return value^
	}

	t := (value^ - min_max[0]) / range
	if t < 0 do t = 0
	if t > 1 do t = 1

	handle_size := Types.Vector2f{
		8,
		size.y,
	}

	handle_pos := Types.Vector2f{
		pos.x + t * size.x - handle_size.x * 0.5,
		pos.y,
	}

	Renderer.DrawRect(ctx.renderer, handle_pos, handle_size, slide_color, true, 0)

	return value^
}

/*
renders text to the renderer in ctx
this is just a wrapper over Renderer.DrawTexture to improve code readability
@param ctx a pointer to the UIContext to use for state and rendering
@param pos the position on the screen to render the text
@param text the text to render
@param rot optional rotation of the text
*/
Text :: proc(
	ctx: ^UIContext,
    pos: Types.Vector2f,
    text: ^Renderer.Texture,
    rot: f64 = 0.0
) {
    Renderer.DrawTexture(ctx.renderer, text, pos, rot)
}

/*
renders an image to the renderer in ctx
this is just a wrapper over Renderer.DrawTexture to improve code readability
@param ctx a pointer to the UIContext to use for state and rendering
@param pos the position on the screen to render the image
@param image the image texture to render
@param rot optional rotation of the image
*/
Image :: proc(
	ctx: ^UIContext,
	pos: Types.Vector2f,
	image: ^Renderer.Texture,
    rot: f64 = 0.0
) {
    Renderer.DrawTexture(ctx.renderer, image, pos, rot)
}

/*
renders a panel to the renderer in ctx
this is just a wrapper over Renderer.DrawRect to improve code readability
@param ctx a pointer to the UIContext to use for state and rendering
@param pos the position on the screen to render the panel
@param color the color of the panel
@param rot optional rotation of the panel
*/
Panel :: proc(
	ctx: ^UIContext,
	pos, size: Types.Vector2f,
	color: Types.Color,
    rot: f32 = 0.0,
) {
	Renderer.DrawRect(ctx.renderer, pos, size, color, true, rot)
}

/*
a dialog box with text and a yes or no option
@param title the title for the dialog window
@param text the text for the dialog window
@param type the type of message box. Options: (ERROR, WARN, INFO)
@param background_color the background color of the dialog
@param text_color the text color of the dialog
@param button_border_color the color of the border of the buttons
@param button_color the color of the buttons
@param button_select_color the color of the button when it is selected
@return a bool signifying yes: true or no: false
*/
YesNoDialog :: proc(
	title: string,
	text: string,
	type: MessageBoxType,
	background_color    := [3]u8{255, 255, 255},
	text_color          := [3]u8{0, 0, 0},
	button_border_color := [3]u8{0, 0, 0},
	button_color        := [3]u8{255, 255, 255},
	button_select_color := [3]u8{191, 191, 191},
) -> bool {
	return ShowTwoButtonDialog(
		title, text, type,
		"yes", "no",
		background_color,
		text_color,
		button_border_color,
		button_color,
		button_select_color,
	)
}

/*
a dialog box with text and a ok or cancel option
@param title the title for the dialog window
@param text the text for the dialog window
@param type the type of message box. Options: (ERROR, WARN, INFO)
@param background_color the background color of the dialog
@param text_color the text color of the dialog
@param button_border_color the color of the border of the buttons
@param button_color the color of the buttons
@param button_select_color the color of the button when it is selected
@return a bool signifying ok: true or cancel: false
*/
OkCancelDialog :: proc(
	title: string,
	text: string,
	type: MessageBoxType,
	background_color    := [3]u8{255, 255, 255},
	text_color          := [3]u8{0, 0, 0},
	button_border_color := [3]u8{0, 0, 0},
	button_color        := [3]u8{255, 255, 255},
	button_select_color := [3]u8{191, 191, 191},
) -> bool {
	return ShowTwoButtonDialog(
		title, text, type,
		"ok", "cancel",
		background_color,
		text_color,
		button_border_color,
		button_color,
		button_select_color,
	)
}

/*
a dialog box with text and a confirm or deny option
@param title the title for the dialog window
@param text the text for the dialog window
@param type the type of message box. Options: (ERROR, WARN, INFO)
@param background_color the background color of the dialog
@param text_color the text color of the dialog
@param button_border_color the color of the border of the buttons
@param button_color the color of the buttons
@param button_select_color the color of the button when it is selected
@return a bool signifying confirm: true or deny: false
*/
ConfirmDenyDialog :: proc(
	title: string,
	text: string,
	type: MessageBoxType,
	background_color    := [3]u8{255, 255, 255},
	text_color          := [3]u8{0, 0, 0},
	button_border_color := [3]u8{0, 0, 0},
	button_color        := [3]u8{255, 255, 255},
	button_select_color := [3]u8{191, 191, 191},
) -> bool {
	return ShowTwoButtonDialog(
		title, text, type,
		"confirm", "deny",
		background_color,
		text_color,
		button_border_color,
		button_color,
		button_select_color,
	)
}

/*
a dialog box with text and custom two options
@param title the title for the dialog window
@param text the text for the dialog window
@param type the type of message box. Options: (ERROR, WARN, INFO,)
@param accept_label a string for the name of option 1
@param deny_label a string for the name of option 2
@param background_color the background color of the dialog
@param text_color the text color of the dialog
@param button_border_color the color of the border of the buttons
@param button_color the color of the buttons
@param button_select_color the color of the button when it is selected
@return a bool signifying option_1: true or option_2: false
*/
ShowTwoButtonDialog :: proc(
	title: string,
	text: string,
	type: MessageBoxType,
	accept_label: string,
	deny_label: string,
	background_color: [3]u8,
	text_color: [3]u8,
	button_border_color: [3]u8,
	button_color: [3]u8,
	button_select_color: [3]u8,
) -> bool {

	buttons := [2]sdl2.MessageBoxButtonData{
		{flags = {.RETURNKEY_DEFAULT}, buttonid = 0, text = strings.clone_to_cstring(accept_label, context.temp_allocator)},
		{flags = {.ESCAPEKEY_DEFAULT}, buttonid = 1, text = strings.clone_to_cstring(deny_label, context.temp_allocator)},
	}

	color_theme := sdl2.MessageBoxColorScheme{
		colors = {
			.BACKGROUND        = {background_color[0], background_color[1], background_color[2]},
			.TEXT              = {text_color[0], text_color[1], text_color[2]},
			.BUTTON_BORDER     = {button_border_color[0], button_border_color[1], button_border_color[2]},
			.BUTTON_BACKGROUND = {button_color[0], button_color[1], button_color[2]},
			.BUTTON_SELECTED   = {button_select_color[0], button_select_color[1], button_select_color[2]},
		},
	}

	data := sdl2.MessageBoxData{
		flags       = {cast(sdl2.MessageBoxFlag)type, .BUTTONS_LEFT_TO_RIGHT},
		window      = nil,
		title       = strings.clone_to_cstring(title, context.temp_allocator),
		message     = strings.clone_to_cstring(text, context.temp_allocator),
		numbuttons  = 2,
		buttons     = raw_data(buttons[:]),
		colorScheme = &color_theme,
	}

	button_id: i32
	sdl2.ShowMessageBox(&data, &button_id)
	return button_id == 0
}