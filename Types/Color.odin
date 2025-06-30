package Types

import "core:simd"
import "vendor:sdl2"

// SIMD-backed color type
Color :: #simd[4]u8

// SDL2 conversion
ColorFromSDL :: proc(c: sdl2.Color) -> Color {
	color: Color = {c.r, c.g, c.b, c.a}
    return color
}

ColorToSDL :: proc(c: Color) -> sdl2.Color {
	return sdl2.Color{r = simd.extract(c, 0), g = simd.extract(c, 1), b = simd.extract(c, 2), a = simd.extract(c, 3)}
}

// Arithmetic operations
ColorAdd :: proc(a, b: Color) -> Color {
	return simd.add(a, b)
}

ColorSub :: proc(a, b: Color) -> Color {
	return simd.sub(a, b)
}

ColorMul :: proc(a, b: Color) -> Color {
	return simd.mul(a, b)
}

ColorDiv :: proc(a, b: Color) -> Color {
	return simd.div(a, b)
}