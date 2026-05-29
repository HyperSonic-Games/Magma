package Renderer

import "core:strings"
import "vendor:sdl2/ttf"
import "core:simd"
import "../../Types"
import "../../Util"

import "vendor:sdl2"


Texture :: sdl2.Texture

/*
clears the screen of the renderer with a color
@param cxt the renderer context to clear
@param color the rgba value to clear the screen with
*/
ClearScreen :: proc(ctx: ^RenderContext, color: Types.Color) {
    sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface);
    sdl2.SetRenderDrawColor(ctx.Renderer, simd.extract(color, 0), simd.extract(color, 1), simd.extract(color, 2), simd.extract(color, 3));
    sdl2.RenderClear(ctx.Renderer);
}

/*
renders the current data in the renderer to the window
@param ctx the renderer context to render to the window that it owns
*/
PresentScreen :: proc(ctx: ^RenderContext) {
    sdl2.SetRenderTarget(ctx.Renderer, nil);
    sdl2.RenderPresent(ctx.Renderer);
}

/*
draws a rectangle to the renderer with optional rotation
@param ctx the renderer to draw to
@param pos the top-left point of the rect
@param size the size of the rect
@param color the RGBA color of the rect
@param filled flag whether to fill the rect
@param rot rotation in degrees (clockwise), default is 0
*/
DrawRect :: proc(ctx: ^RenderContext, pos: Types.Vector2f, size: Types.Vector2f, color: Types.Color, filled: bool = true, rot: f32 = 0.0) {
    rect: sdl2.FRect = sdl2.FRect{
        x = pos[0],
        y = pos[1],
        w = size[0],
        h = size[1]
    }

    center: sdl2.FPoint = sdl2.FPoint{
        x = rect.w / 2.0,
        y = rect.h / 2.0,
    }

    sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface)
    sdl2.SetRenderDrawColor(ctx.Renderer, simd.extract(color, 0), simd.extract(color, 1), simd.extract(color, 2), simd.extract(color, 3))

    if rot == 0.0 {
        if filled {
            sdl2.RenderFillRectF(ctx.Renderer, &rect)
        } else {
            sdl2.RenderDrawRectF(ctx.Renderer, &rect)
        }
    } else {
        tex: ^sdl2.Texture
        tex = sdl2.CreateTexture(ctx.Renderer, sdl2.PixelFormatEnum.RGBA8888, sdl2.TextureAccess.TARGET, cast(i32)rect.w, cast(i32)rect.h)
        sdl2.SetTextureBlendMode(tex, sdl2.BlendMode.BLEND)
        sdl2.SetRenderTarget(ctx.Renderer, tex)
        sdl2.RenderClear(ctx.Renderer)
        sdl2.SetRenderDrawColor(ctx.Renderer, simd.extract(color, 0), simd.extract(color, 1), simd.extract(color, 2), simd.extract(color, 3))

        tmp_rect := sdl2.FRect{ x = 0, y = 0, w = rect.w, h = rect.h }
        if filled {
            sdl2.RenderFillRectF(ctx.Renderer, &tmp_rect)
        } else {
            sdl2.RenderDrawRectF(ctx.Renderer, &tmp_rect)
        }

        sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface)
        sdl2.RenderCopyExF(ctx.Renderer, tex, nil, &rect, cast(f64)rot, &center, .NONE)
        sdl2.DestroyTexture(tex)
    }
}

/*
draws a line to the renderer
@param ctx the renderer to draw to
@param point1 the start point of the line
@param point2 the end point of the line
@param color the RGBA color of the line
*/
DrawLine :: proc(ctx: ^RenderContext, point1: Types.Vector2f, point2: Types.Vector2f, color: Types.Color) {
    sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface)
    sdl2.SetRenderDrawColor(ctx.Renderer, simd.extract(color, 0), simd.extract(color, 1), simd.extract(color, 2), simd.extract(color, 3))
    sdl2.RenderDrawLineF(ctx.Renderer,
        point1[0],
        point1[1],
        point2[0],
        point2[1])
}

/*
draws an SDL2 texture to the renderer with optional rotation
Can be used with an image loader, text renderer or any SDL2 code that creates a texture
@param ctx the renderer to draw to
@param texture the SDL2 texture to render
@param pos the top-left position to draw the texture
@param rot the rotation angle (in degrees)
*/
DrawTexture :: proc(ctx: ^RenderContext, texture: ^Texture, pos: Types.Vector2f, rot: f64) {
    w, h: i32
    _ = sdl2.QueryTexture(texture, nil, nil, &w, &h)

    dst: sdl2.FRect = sdl2.FRect{
        x = pos[0],
        y = pos[1],
        w = cast(f32)w,
        h = cast(f32)h,
    }

    center: sdl2.FPoint = sdl2.FPoint{
        x = dst.w / 2.0,
        y = dst.h / 2.0,
    }

    sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface)
    sdl2.RenderCopyExF(ctx.Renderer, texture, nil, &dst, rot, &center, .NONE)
}

DrawTextureScaled :: proc(
    ctx: ^RenderContext,
    texture: ^sdl2.Texture,
    pos: Types.Vector2f,
    scale: Types.Vector2f,
    rot: f64 = 0.0,
) -> bool {

    if texture == nil || scale[0] <= 0 || scale[1] <= 0 {
        return false
    }

    w, h: i32
    if sdl2.QueryTexture(texture, nil, nil, &w, &h) != 0 {
        return false
    }

    dst := sdl2.FRect{
        pos.x,
        pos.y,
        f32(w) * scale[0],
        f32(h) * scale[1],
    }

    sdl2.RenderCopyExF(
        ctx.Renderer,
        texture,
        nil,
        &dst,
        rot,
        nil,
        .NONE,
    )

    return true
}

/*
rasterizes UTF-8 text to create a texture of rendered text ready to draw to the renderer
NOTE: this is a VERY expensive operation and if the text does not change often you should reuse the result
@param ctx rendering context used to create the GPU texture
@param text string to render
@param font font used for rasterization loaded from the FontSystem
@param color RGBA color of the rendered text
@param wrap maximum pixel width before line wrapping occurs
@return the text rendered to a new texture and the size of the texture
*/
RenderTextToTexture :: proc(
	ctx: ^RenderContext,
	text: string,
	font: ^ttf.Font,
	color: Types.Color,
	wrap: u32,
) -> (renderer_text: ^Texture, width: u32, height: u32) {

	if ctx == nil || font == nil || len(text) == 0 {
		return nil, {}, {}
	}

	if ttf.WasInit() == 0 {
		if ttf.Init() != 0 {
			Util.Log(.ERROR, "MAGMA_ENGINE", "2D_RENDERER_RENDER_TEXT_TO_TEXTURE", "Could not init SDL2_ttf")
		}
	}

	c_text := strings.clone_to_cstring(text, context.temp_allocator)

	surface := ttf.RenderUTF8_Blended_Wrapped(
		font,
		c_text,
		Types.ColorToSDL(color),
		wrap,
	)

	if surface == nil {
		return nil, {}, {}
	}

	texture := sdl2.CreateTextureFromSurface(ctx.Renderer, surface)
    sdl2.FreeSurface(surface)
	if texture == nil {
		return nil, {}, {}
	}
    w, h: i32
    sdl2.QueryTexture(texture, nil, nil, &w, &h)

	return texture, cast(u32)w, cast(u32)h
}