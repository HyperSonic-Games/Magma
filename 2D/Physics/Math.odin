package Physics

// Default scale value, can be overridden at runtime
@private
METER_TO_PIXEL_SCALE_VALUE_DEFAULT :: #config(magma_physics_meter_to_pixel_scale_default, 64.0)

// Current scale factor (mutable)
@private
@(link_section="MAGMA_ENGINE_GLOBALS")
meter_to_pixel_scale: f32 = METER_TO_PIXEL_SCALE_VALUE_DEFAULT

/*
 * SetMeterToPixelScale sets a new meters-to-pixels scale value at runtime.
 * @param new_scale the new scale factor to use
 * @note Panics if new_scale is <= 0
*/
SetMeterToPixelScale :: proc(new_scale: f32) {
    if new_scale <= 0.0 {
        panic("METER_TO_PIXEL_SCALE can't be less than or equal to 0")
    }
    meter_to_pixel_scale = new_scale
}

/*
 * GetMeterToPixelScale returns the current meters-to-pixels scale factor.
 * @return f32 current scale factor
*/
GetMeterToPixelScale :: proc() -> f32 {
    return meter_to_pixel_scale
}

/*
 * MetersToPixels converts a distance in meters to pixels using the current scale factor.
 * @param meters distance in meters
 * @return f32 equivalent distance in pixels
*/
MetersToPixels :: proc(meters: f32) -> f32 {
    return meters * meter_to_pixel_scale
}

/*
 * PixelsToMeters converts a distance in pixels to meters using the current scale factor.
 * @param pixels distance in pixels
 * @return f32 equivalent distance in meters
*/
PixelsToMeters :: proc(pixels: f32) -> f32 {
    return pixels / meter_to_pixel_scale
}
