package Util


// Default scale value, can be overridden at runtime
@private
METER_TO_PIXEL_SCALE_VALUE :: #config(magma_meter_to_pixel_scale, 64.0)

// Current scale factor (mutable)
@private
meter_to_pixel_scale: f32 = METER_TO_PIXEL_SCALE_VALUE

// Set a new scale value at runtime
SetMeterToPixelScale :: proc(new_scale: f32) {
    // Prevent invalid values like zero or negative
    if new_scale <= 0.0 {
        panic("METER_TO_PIXEL_SCALE Can't be less than or equal to 0")
    }
    meter_to_pixel_scale = new_scale
}

// Get the current scale value
GetMeterToPixelScale :: proc() -> f32 {
    return meter_to_pixel_scale
}

// Convert meters to pixels using the current scale
MetersToPixels :: proc(meters: f32) -> f32 {
    return meters * meter_to_pixel_scale
}

// Convert pixels back to meters using the current scale
PixelsToMeters :: proc(pixels: f32) -> f32 {
    return pixels / meter_to_pixel_scale
}
