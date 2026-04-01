package Types

import "core:simd"
import "vendor:sdl2"

// SIMD-backed color type, representing RGBA channels as 4 unsigned 8-bit integers
Color :: #simd[4]u8


/*
internal function that converts SDL2's Color data structure to Magma's Color data structure.
@param c the SDL2 Color data structure
@return Magma's Color data structure
*/
ColorFromSDL :: proc(c: sdl2.Color) -> Color {
    color: Color = {c.r, c.g, c.b, c.a}
    return color
}

/*
internal function that converts Magma's Color data structure to SDL2's Color data structure.
@param c the Magma Color data structure
@return SDL2's Color data structure
*/
ColorToSDL :: proc(c: Color) -> sdl2.Color {
    return sdl2.Color{
        r = simd.extract(c, 0), 
        g = simd.extract(c, 1), 
        b = simd.extract(c, 2), 
        a = simd.extract(c, 3)
    }
}



/*
performs per-channel addition of two Colors.
@param a first Color operand
@param b second Color operand
@return resulting Color after addition
*/
ColorAdd :: proc(a, b: Color) -> Color {
    return simd.clamp(simd.add(a, b), {0, 0, 0, 0,}, {255, 255, 255, 100})
}

/*
performs per-channel subtraction of two Colors.
@param a first Color operand
@param b second Color operand
@return resulting Color after subtraction
*/
ColorSub :: proc(a, b: Color) -> Color {
    return simd.clamp(simd.sub(a, b), {0, 0, 0, 0}, {255, 255, 255, 255})
}

/*
performs per-channel multiplication of two Colors, clamped to valid RGBA ranges.
@param a first Color operand
@param b second Color operand
@return resulting Color after multiplication and clamping
*/
ColorMul :: proc(a, b: Color) -> Color {
    return simd.clamp(simd.mul(a, b), {0, 0, 0 ,0}, {255, 255, 255, 255})
}

/*
performs per-channel division of two Colors, with float casting for precision.
The result is clamped to valid RGBA ranges, with alpha clamped to 100 max.
@param a numerator Color
@param b denominator Color
@return resulting Color after division and clamping
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
returns the color negation (inversion) of the RGB channels.
Note: this operation is not performed using SIMD intrinsics directly.
@param a Color to negate
@return negated Color with clamped alpha
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
converts a color to an array
@param color The color to convert to an array
@return a u8 array of four values in the format (R, G, B, A)
*/
ColorToArray :: proc(color: Color) -> [4]u8 {
    array: [4]u8
    array[0] = simd.extract(color, 0)
    array[1] = simd.extract(color, 1)
    array[2] = simd.extract(color, 2)
    array[3] = simd.extract(color, 3)
    return array
}