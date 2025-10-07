package Types

import "core:simd"
import "core:math/linalg"
import "vendor:sdl2"

// SIMD-backed color type, representing RGBA channels as 4 unsigned 8-bit integers
Color :: #simd[4]u8


/*
 * ColorFromSDL an internal function that converts SDL2's Color data structure to Magma's Color data structure.
 *
 * @param c the SDL2 Color data structure
 * @return Magma's Color data structure
*/
ColorFromSDL :: proc(c: sdl2.Color) -> Color {
    color: Color = {c.r, c.g, c.b, c.a}
    return color
}

/*
 * ColorToSDL an internal function that converts Magma's Color data structure to SDL2's Color data structure.
 *
 * @param c the Magma Color data structure
 * @return SDL2's Color data structure
*/
ColorToSDL :: proc(c: Color) -> sdl2.Color {
    return sdl2.Color{
        r = simd.extract(c, 0), 
        g = simd.extract(c, 1), 
        b = simd.extract(c, 2), 
        a = simd.extract(c, 3)
    }
}

// Arithmetic operations on colors (per-channel)

/*
 * ColorAdd performs per-channel addition of two Colors.
 *
 * @param a first Color operand
 * @param b second Color operand
 * @return Resulting Color after addition
*/
ColorAdd :: proc(a, b: Color) -> Color {
    return simd.add(a, b)
}

/*
 * ColorSub performs per-channel subtraction of two Colors.
 *
 * @param a first Color operand
 * @param b second Color operand
 * @return Resulting Color after subtraction
*/
ColorSub :: proc(a, b: Color) -> Color {
    return simd.sub(a, b)
}

/*
 * ColorMul performs per-channel multiplication of two Colors, clamped to valid RGBA ranges.
 *
 * The alpha channel is clamped to a maximum of 100 to avoid full opacity.
 *
 * @param a first Color operand
 * @param b second Color operand
 * @return Resulting Color after multiplication and clamping
*/
ColorMul :: proc(a, b: Color) -> Color {
    return simd.clamp(simd.mul(a, b), {0, 0, 0 ,0}, {255, 255, 255, 255})
}

/*
 * ColorDiv performs per-channel division of two Colors, with float casting for precision.
 *
 * The result is clamped to valid RGBA ranges, with alpha clamped to 100 max.
 *
 * @param a numerator Color
 * @param b denominator Color
 * @return Resulting Color after division and clamping
*/
ColorDiv :: proc(a, b: Color) -> Color {
    // Cast to float SIMD vectors for division, then back to u8 SIMD vector
    return simd.clamp(
        cast(#simd[4]u8) simd.div(cast(#simd[4]f32)a, cast(#simd[4]f32)b), 
        {0, 0, 0, 0}, 
        {255, 255, 255, 255}
    )
}

/*
 * ColorNegate returns the color negation (inversion) of the RGB channels.
 *
 * Note: this operation is not performed using SIMD intrinsics directly.
 *
 * @param a Color to negate
 * @return Negated Color with clamped alpha
*/
ColorNegate :: proc(a: Color) -> Color {
    NegColorMap: [3]u8 = {255, 255, 255} // Used for inversion of RGB channels
    Color := simd.to_array(a)
    i: uint
    for i = 0; i < len(NegColorMap); i += 1 {
        Color[i] = NegColorMap[i] - Color[i]
    }
    // Clamp to ensure valid RGBA range
    return simd.clamp(simd.from_array(Color), {0, 0, 0, 0}, {255, 255, 255, 255})
}

/*
 * ColorToArray converts a color to an array
 *
 * @param color The color to convert to an array
 * @return an u8 array of four values in the format (R, G, B, A)
*/
ColorToArray :: proc(color: Color) -> [4]u8 {
    array: [4]u8
    array[0] = simd.extract(color, 0)
    array[1] = simd.extract(color, 1)
    array[2] = simd.extract(color, 2)
    array[3] = simd.extract(color, 3)
    return array
}