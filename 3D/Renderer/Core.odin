package Renderer

import "vendor:raylib/rlgl"

import "../../Types"

WindowCtx :: struct {
    width, height: i32,
    dpi_scale: f32,

    projection: matrix[4,4]f32,
    view:       matrix[4,4]f32,

    clear_color: Types.Color,

    frame_count: u128,
    delta_time:  f32,
}

