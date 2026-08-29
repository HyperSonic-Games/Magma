package UI

import "core:strings"
import "vendor:sdl2"
import "../../Types"
import "../Renderer"
import "../EventSys"
import "../../Util"

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
PointInRect :: #force_inline proc(p, pos, size: Types.Vector2f) -> bool {
	return p.x >= pos.x && p.y >= pos.y && p.x <= pos.x+size.x && p.y <= pos.y+size.y
}

/*
renders a button to the renderer in ctx
@param ctx a pointer to the UIContext to use for state and rendering
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
	color: Types.Color,
	pressed_color: Types.Color,
	r_click: bool = false,
) -> bool {

	p := Types.Vector2f{
		ctx.mouse_input.position.x,
		ctx.mouse_input.position.y,
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
renders a button with text centered inside
@param ctx ui context
@param text used as label
@param pos button position
@param size button size
@param color base color
@param pressed_color pressed color
@param r_click right click mode
@return true if clicked
*/
TextButton :: proc(
	ctx: ^UIContext,
	text: string,
	font: ^Util.FontEntry,
	pos, size: Types.Vector2f,
	color: Types.Color,
	pressed_color: Types.Color,
	r_click: bool = false,
) -> bool {

	clicked := Button(ctx, pos, size, color, pressed_color, r_click)

	if len(text) == 0 || font == nil {
		return clicked
	}

	metrics := Util.GetStringMetrics(font, ctx.renderer.Renderer, text)

	if metrics.x <= 0 || metrics.y <= 0 {
		return clicked
	}

	scale_factor := min(size.x / metrics.x, size.y / metrics.y,)

	scale := Types.Vector2f{scale_factor, scale_factor}

	scaled_size := Types.Vector2f{metrics.x * scale.x, metrics.y * scale.y,}

	text_pos := Types.Vector2f{
		pos.x + (size.x - scaled_size.x) * 0.5,
		pos.y + (size.y - scaled_size.y) * 0.5,
	}

	Text(ctx, font, text, text_pos, scale, 0.0)

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
		ctx.mouse_input.position.x,
		ctx.mouse_input.position.y,
	}
	p := Types.Vector2f{f32(ctx.mouse_input.position[0]), f32(ctx.mouse_input.position[1])}

	hover := PointInRect(p, pos, size)

	clicked := hover && ctx.mouse_input.LClick && !ctx.mouse_input.prev_LClick

	if clicked {
		value^ = !value^
	}

	tex := uncheck_texture
	if value^ {
		tex = check_texture
	}

	if tex != nil {
		Renderer.DrawTextureScaled(ctx.renderer, tex, pos, {1, 1}, 0.0)
	}

	return value^
}

/*
renders a slider that uses an unsigned integer for the value
@param ctx ui context
@param pos slider position
@param size slider size
@param value state pointer
@param min_max range
@param step_size snapping step
@param bar_color bar color
@param slide_color handle color
@return current value
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
		ctx.mouse_input.position.x,
		ctx.mouse_input.position.y,
	}
	p := Types.Vector2f{f32(ctx.mouse_input.position[0]), f32(ctx.mouse_input.position[1])}

	hover := PointInRect(p, pos, size)

	if hover && ctx.mouse_input.LClick {

		t := (p.x - pos.x) / size.x
		t = t < 0 ? 0 : (t > 1 ? 1 : t)

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
	t = t < 0 ? 0 : (t > 1 ? 1 : t)

	handle_size := Types.Vector2f{8, size.y}

	handle_pos := Types.Vector2f{pos.x + t * size.x - handle_size.x * 0.5, pos.y}

	Renderer.DrawRect(ctx.renderer, handle_pos, handle_size, slide_color, true, 0.0)

	return value^
}

/*
renders a slider that uses an signed integer for the value
@param ctx ui context
@param pos slider position
@param size slider size
@param value state pointer
@param min_max range
@param step_size snapping step
@param bar_color bar color
@param slide_color handle color
@return current value
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
		ctx.mouse_input.position.x,
		ctx.mouse_input.position.y,
	}
	p := Types.Vector2f{f32(ctx.mouse_input.position[0]), f32(ctx.mouse_input.position[1])}

	hover := PointInRect(p, pos, size)

	if hover && ctx.mouse_input.LClick {

		t := (p.x - pos.x) / size.x
		t = t < 0 ? 0 : (t > 1 ? 1 : t)

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
	t = t < 0 ? 0 : (t > 1 ? 1 : t)

	handle_size := Types.Vector2f{8, size.y}

	handle_pos := Types.Vector2f{pos.x + t * size.x - handle_size.x * 0.5, pos.y}

	Renderer.DrawRect(ctx.renderer, handle_pos, handle_size, slide_color, true, 0.0)

	return value^
}

/*
renders a slider that uses a float for the value
@param ctx ui context
@param pos slider position
@param size slider size
@param value state pointer
@param min_max range
@param step_size snapping step
@param bar_color bar color
@param slide_color handle color
@return current value
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
		ctx.mouse_input.position.x,
		ctx.mouse_input.position.y,
	}
	p := Types.Vector2f{f32(ctx.mouse_input.position[0]), f32(ctx.mouse_input.position[1])}

	hover := PointInRect(p, pos, size)

	if hover && ctx.mouse_input.LClick {

		t := (p.x - pos.x) / size.x
		t = t < 0 ? 0 : (t > 1 ? 1 : t)

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
	t = t < 0 ? 0 : (t > 1 ? 1 : t)

	handle_size := Types.Vector2f{8, size.y}

	handle_pos := Types.Vector2f{pos.x + t * size.x - handle_size.x * 0.5, pos.y}

	Renderer.DrawRect(ctx.renderer, handle_pos, handle_size, slide_color, true, 0.0)

	return value^
}

/*
renders text to the renderer in ctx
@param ctx ui context
@param font the font to render with
@param text UTF-8 text to render
@param pos text position
@param scale optional scaling factor
@param rot rotation
*/
Text :: proc(
	ctx: ^UIContext,
	font: ^Util.FontEntry,
	text: string,
	pos: Types.Vector2f,
	scale: Types.Vector2f = {1, 1},
	rot: f64 = 0.0,
) {
	if len(text) == 0 || ctx == nil ||font == nil {
		return
	}

	sdl2.SetRenderTarget(ctx.renderer.Renderer, ctx.renderer.RenderSurface)
	metrics := Util.GetStringMetrics(font, ctx.renderer.Renderer, text)
	scaled_metrics := Types.Vector2f{metrics.x * scale.x, metrics.y * scale.y}

	global_center := Types.Vector2f{pos.x + scaled_metrics.x * 0.5, pos.y + scaled_metrics.y * 0.5,}

	curr_x := pos.x

	for char in text {
		glyph, success := Util.EnsureGlyphCached(font, ctx.renderer.Renderer, char)
		if !success {
			continue
		}

		if glyph.SrcRect.w > 0 && glyph.SrcRect.h > 0 {
			glyph_x := curr_x + f32(glyph.MinX) * scale.x
			glyph_y := pos.y + f32(font.LineHeight - glyph.MaxY) * scale.y
			glyph_w := f32(glyph.SrcRect.w) * scale.x
			glyph_h := f32(glyph.SrcRect.h) * scale.y

			Dst := sdl2.FRect{glyph_x, glyph_y, glyph_w, glyph_h}

			if rot == 0.0 {
				sdl2.RenderCopyF(ctx.renderer.Renderer, font.AtlasTexture, &glyph.SrcRect, &Dst)
			}
			else {
				local_center := sdl2.FPoint{(global_center.x - Dst.x), (global_center.y - Dst.y)}
				
				sdl2.RenderCopyExF(
					ctx.renderer.Renderer, 
					font.AtlasTexture, 
					&glyph.SrcRect, 
					&Dst, 
					rot, 
					&local_center, 
					.NONE,
				)
			}
		}
		curr_x += f32(glyph.AdvanceX) * scale.x
	}
}

/*
renders an image to the renderer in ctx
this is just a wrapper over Renderer.DrawTexture to improve code readability
@param ctx ui context
@param pos image position
@param image texture
@param scale optional scaling factor
@param rot rotation
*/
Image :: proc(
	ctx: ^UIContext,
	pos: Types.Vector2f,
	image: ^Renderer.Texture,
	scale: Types.Vector2f = {1, 1},
	rot: f64 = 0.0,
) {
	if image == nil {
		return
	}
	Renderer.DrawTextureScaled(ctx.renderer, image, pos, scale, rot)
}

/*
renders a panel to the renderer in ctx
this is just a wrapper over Renderer.DrawRect to improve code readability
@param ctx ui context
@param pos panel position
@param size panel size
@param color panel color
@param rot optional rotation
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
@param title title text
@param text body text
@param type message type
@param background_color background color
@param text_color text color
@param button_border_color border color
@param button_color button color
@param button_select_color selected button color
@return true if yes false if no
*/
YesNoDialog :: proc(
	title: string,
	text: string,
	type: MessageBoxType,
	background_color := Types.Color{255, 255, 255, 255},
	text_color := Types.Color{0, 0, 0, 255},
	button_border_color := Types.Color{0, 0, 0, 255},
	button_color := Types.Color{255, 255, 255, 255},
	button_select_color := Types.Color{191, 191, 191, 255},
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
a dialog box with text and an ok or cancel option
@param title title text
@param text body text
@param type message type
@param background_color background color
@param text_color text color
@param button_border_color border color
@param button_color button color
@param button_select_color selected button color
@return true if ok false if cancel
*/
OkCancelDialog :: proc(
	title: string,
	text: string,
	type: MessageBoxType,
	background_color := Types.Color{255, 255, 255, 255},
	text_color := Types.Color{0, 0, 0, 255},
	button_border_color := Types.Color{0, 0, 0, 255},
	button_color := Types.Color{255, 255, 255, 255},
	button_select_color := Types.Color{191, 191, 191, 255},
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
a dialog box with text and confirm/deny option
@param title title text
@param text body text
@param type message type
@param background_color background color
@param text_color text color
@param button_border_color border color
@param button_color button color
@param button_select_color selected button color
@return true if confirm false if deny
*/
ConfirmDenyDialog :: proc(
	title: string,
	text: string,
	type: MessageBoxType,
	background_color := Types.Color{255, 255, 255, 255},
	text_color := Types.Color{0, 0, 0, 255},
	button_border_color := Types.Color{0, 0, 0, 255},
	button_color := Types.Color{255, 255, 255, 255},
	button_select_color := Types.Color{191, 191, 191, 255},
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
shows a generic two button dialog
@param title the title of the dialog
@param text the discription of the dialog
@param type the type of dialog
@param accept_label the text for the accept button
@param deny_label the text for the deny_label
@param background_color the color for the background
@param text_color the color for the text
@param button_border_color the color for the border of the buttons
@param button_select_color the color of the buttons when selected
*/
ShowTwoButtonDialog :: proc(
	title: string,
	text: string,
	type: MessageBoxType,
	accept_label: string,
	deny_label: string,
	background_color: Types.Color,
	text_color: Types.Color,
	button_border_color: Types.Color,
	button_color: Types.Color,
	button_select_color: Types.Color,
) -> bool {

	buttons := [2]sdl2.MessageBoxButtonData{
		{
			flags = {.RETURNKEY_DEFAULT},
			buttonid = 0,
			text = strings.clone_to_cstring(accept_label, context.temp_allocator)
		},
		{
			flags = {.ESCAPEKEY_DEFAULT},
			buttonid = 1,
			text = strings.clone_to_cstring(deny_label, context.temp_allocator)
		}
	}

	b_color := Types.ColorToSDL(background_color)
	t_color := Types.ColorToSDL(text_color)
	bb_color := Types.ColorToSDL(button_border_color)
	bt_color := Types.ColorToSDL(button_color)
	bs_color := Types.ColorToSDL(button_select_color)

	color_theme := sdl2.MessageBoxColorScheme{
		colors = {
			.BACKGROUND = {b_color.r, b_color.g, b_color.b},
			.TEXT = {t_color.r, t_color.g, t_color.b},
			.BUTTON_BORDER = {bb_color.r, bb_color.g, bb_color.b},
			.BUTTON_BACKGROUND = {bt_color.r, bt_color.g, bt_color.b},
			.BUTTON_SELECTED = {bs_color.r, bs_color.g, bs_color.b},
		},
	}

	data := sdl2.MessageBoxData{
		flags = {cast(sdl2.MessageBoxFlag)type, .BUTTONS_LEFT_TO_RIGHT},
		window = nil,
		title = strings.clone_to_cstring(title, context.temp_allocator),
		message = strings.clone_to_cstring(text, context.temp_allocator),
		numbuttons = 2,
		buttons = raw_data(buttons[:]),
		colorScheme = &color_theme,
	}

	button_id: i32
	sdl2.ShowMessageBox(&data, &button_id)
	return button_id == 0
}