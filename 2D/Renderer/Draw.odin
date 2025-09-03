package Renderer

import "core:c"
import "core:simd"
import "core:fmt"
import "../../Util"
import "../../Types"

import "vendor:sdl2"
import "vendor:sdl2/image"
import "vendor:sdl2/ttf"

/*
 * ClearScreen clears the screen of the renderer win a color
 * @param cxt the renderer context to clear
 * @param color the rgba value to clear the screen with
*/
ClearScreen :: proc(ctx: ^RenderContext, color: Types.Color) {
    sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface);
    sdl2.SetRenderDrawColor(ctx.Renderer, simd.extract(color, 0), simd.extract(color, 1), simd.extract(color, 2), simd.extract(color, 3));
    sdl2.RenderClear(ctx.Renderer);
}

/*
 * PresentScreen renders the current data in the renderer to the window
 * @param ctx the renderer context to render to the window
*/
PresentScreen :: proc(ctx: ^RenderContext) {
    sdl2.SetRenderTarget(ctx.Renderer, nil);
    sdl2.RenderPresent(ctx.Renderer);
}

/*
 * DrawRect draws a rectangle to the renderer with optional rotation
 * @param ctx the renderer to draw to
 * @param pos the top-left point of the rect
 * @param size the size of the rect
 * @param color the RGBA color of the rect
 * @param filled flag whether to fill the rect
 * @param rot rotation in degrees (clockwise), default is 0
*/
DrawRect :: proc(ctx: ^RenderContext, pos: Types.Vector2f, size: Types.Vector2f, color: Types.Color, filled: bool = true, rot: f32 = 0.0) {
    rect: sdl2.FRect = sdl2.FRect{
        x = auto_cast Types.Vector2fGetX(pos),
        y = auto_cast Types.Vector2fGetY(pos),
        w = auto_cast Types.Vector2fGetX(size),
        h = auto_cast Types.Vector2fGetY(size),
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
 * DrawLine draws a line to the renderer
 * @param ctx the renderer to draw to
 * @param point1 the start point of the line
 * @param point2 the end point of the line
 * @param color the RGBA color of the line
*/
DrawLine :: proc(ctx: ^RenderContext, point1: Types.Vector2f, point2: Types.Vector2f, color: Types.Color) {
    sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface)
    sdl2.SetRenderDrawColor(ctx.Renderer, simd.extract(color, 0), simd.extract(color, 1), simd.extract(color, 2), simd.extract(color, 3))
    sdl2.RenderDrawLineF(ctx.Renderer,
        auto_cast Types.Vector2fGetX(point1),
        auto_cast Types.Vector2fGetY(point1),
        auto_cast Types.Vector2fGetX(point2),
        auto_cast Types.Vector2fGetY(point2))
}

/*
 * DrawTexture draws an SDL2 texture to the renderer with optional rotation
 * Meant to be used with a image loader
 * @param ctx the renderer to draw to
 * @param texture the SDL2 texture to render
 * @param pos the top-left position to draw the texture
 * @param rot the rotation angle (in degrees, clockwise)
*/
DrawTexture :: proc(ctx: ^RenderContext, texture: ^sdl2.Texture, pos: Types.Vector2f, rot: f64) {
    w, h: i32
    _ = sdl2.QueryTexture(texture, nil, nil, &w, &h)

    dst: sdl2.FRect = sdl2.FRect{
        x = auto_cast Types.Vector2fGetX(pos),
        y = auto_cast Types.Vector2fGetY(pos),
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
