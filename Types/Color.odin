package Types

import "core:simd"
import "core:math/linalg"
import "vendor:sdl2"

// SIMD-backed color type
Color :: #simd[4]u8

// SDL2 conversion stuff

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
	return simd.clamp(simd.mul(a, b), {0, 0, 0 ,0}, {255, 255, 255, 100})
}

ColorDiv :: proc(a, b: Color) -> Color {
	// eww look at that ugly cast
	return simd.clamp(cast(#simd[4]u8)simd.div(cast(#simd[4]f32)a, cast(#simd[4]f32)b), {0, 0, 0, 0}, {255, 255, 255, 100})
}

// NOTE: this operation is not simd
ColorNegate :: proc(a: Color) -> Color {
	NegColorMap: [3]u8 = {255, 255, 255}
	Color := simd.to_array(a)
	i: uint
	for i=0; i < len(NegColorMap); i += 1 {
		Color[i] = NegColorMap[i] - Color[i]
	}
	return simd.clamp(simd.from_array(Color), {0, 0, 0, 0}, {255, 255, 255, 100})
	

}