package Types

import "vendor:sdl2"

RGBA :: sdl2.Color

RGBAGetRed :: proc(color: RGBA) -> (Red: u8) {
    return color.r
}

RGBAGetGreen :: proc(color: RGBA) -> (Green: u8) {
    return color.g
}

RGBAGetBlue :: proc(color: RGBA) -> (Blue: u8) {
    return color.b
}

RGBAGetAlpha :: proc(color: RGBA) -> (Alpha: u8) {
    return color.a
}

RGBASetRed :: proc(color: RGBA, value: u8){
    color := color
    color.r = value
}

RGBASetGreen :: proc(color: RGBA, value: u8 ) {
    color := color
    color.g = value
}

RGBASetBlue :: proc(color: RGBA, value: u8) {
    color := color
    color.b = value
}

RGBASetAlpha :: proc(color: RGBA, value: u8) {
        color := color
        color.a = value
}

RGBAdd :: proc(a: RGBA, b: RGBA) -> (color: RGBA) {
    result: RGBA = {r = a.r + b.r, g = a.g + b.g, b = a.b + b.b, a = a.a + b.b}
    return result
}

RGBSub :: proc(a: RGBA, b: RGBA) -> (color: RGBA) {
    result: RGBA = {r = a.r - b.r, g = a.g - b.g, b = a.b - b.b, a = a.a - b.a}
    return result
}

RGBMul :: proc(a: RGBA, b: RGBA) -> (color: RGBA) {
    result: RGBA = {r = a.r * b.r, g = a.g * b.g, b = a.b * b.b, a = a.a * b.a}
    return result
}

RGBDiv :: proc(a: RGBA, b: RGBA) -> (color: RGBA) {
    result: RGBA = {r = a.r / b.r, g = a.g / b.g, b = a.b / b.b, a = a.a / b.a}
    return result
}



RGBABlend :: proc(a: RGBA, b: RGBA) -> RGBA {
    alpha_a := f32(a.a) / 255.0
    alpha_b := f32(b.a) / 255.0
    out_a := alpha_a + alpha_b * (1.0 - alpha_a)

    if out_a == 0.0 {
        return RGBA{r=0, g=0, b=0, a=0}
    }

    r := ((f32(a.r) * alpha_a) + (f32(b.r) * alpha_b * (1.0 - alpha_a))) / out_a
    g := ((f32(a.g) * alpha_a) + (f32(b.g) * alpha_b * (1.0 - alpha_a))) / out_a
    b := ((f32(a.b) * alpha_a) + (f32(b.b) * alpha_b * (1.0 - alpha_a))) / out_a

    return RGBA{
        r = u8(clamp(r, 0.0, 255.0)),
        g = u8(clamp(g, 0.0, 255.0)),
        b = u8(clamp(b, 0.0, 255.0)),
        a = u8(clamp(out_a * 255.0, 0.0, 255.0))
    }
}
