package Renderer



GLFWXYFlipInt :: proc(#any_int x, #any_int y, #any_int window_height: int) -> (int, int) {
	return x, window_height - y
}

GLFWXYFlipFloat32 :: proc(x, y : f32, window_height: int) -> (f32, f32) {
	return x, cast(f32)window_height - y
}

GLFWXYFlipFloat64 :: proc(x, y : f64, window_height: int) -> (f64, f64) {
	return x, cast(f64)window_height - y
}