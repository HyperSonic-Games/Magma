package Renderer

import "core:simd"
import "core:fmt"
import "../../Util"
import "../../Types"

import "vendor:sdl2"
import "vendor:sdl2/image"
import "vendor:sdl2/ttf"


ClearScreen :: proc(ctx: ^RenderContext, Color: Types.Color) {
    sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface);
    sdl2.SetRenderDrawColor(ctx.Renderer, simd.extract(Color, 0), simd.extract(Color, 1), simd.extract(Color, 2), simd.extract(Color, 3));
    sdl2.RenderClear(ctx.Renderer);
}

PresentScreen :: proc(ctx: ^RenderContext) {
    // Reset to default render target (the window)
    sdl2.SetRenderTarget(ctx.Renderer, nil);
    sdl2.RenderPresent(ctx.Renderer);
}

DrawRect :: proc(ctx: ^RenderContext, x, y, w, h: i32, Color: Types.Color, filled: bool = true) {
    rect: sdl2.Rect = sdl2.Rect{x = x, y = y, w = w, h = h};
    sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface);
    sdl2.SetRenderDrawColor(ctx.Renderer, simd.extract(Color, 0), simd.extract(Color, 1), simd.extract(Color, 2), simd.extract(Color, 3));
    if filled {
        sdl2.RenderFillRect(ctx.Renderer, &rect);
    } else {
        sdl2.RenderDrawRect(ctx.Renderer, &rect);
    }
}

DrawLine :: proc(ctx: ^RenderContext, x1, y1, x2, y2: i32, Color: Types.Color) {
    sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface);
    sdl2.SetRenderDrawColor(ctx.Renderer, simd.extract(Color, 0), simd.extract(Color, 1), simd.extract(Color, 2), simd.extract(Color, 3));
    sdl2.RenderDrawLine(ctx.Renderer, x1, y1, x2, y2);
}

DrawTexture :: proc(ctx: ^RenderContext, texture: ^sdl2.Texture, src, dst: ^sdl2.Rect) {
    sdl2.SetRenderTarget(ctx.Renderer, ctx.RenderSurface);
    sdl2.RenderCopy(ctx.Renderer, texture, src, dst);
}
