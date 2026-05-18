package Renderer

import "core:math"
import "core:time"
import "vendor:sdl2"
import "vendor:sdl2/image"

import "../../Util"

/*
frees an SDL allocated texture
@param texture the texture to free
*/
UnloadTexture :: proc(texture: ^Texture) {
    sdl2.DestroyTexture(texture)
}

/*
loads a BMP image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedBMP :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadBMP_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a CUR image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedCUR :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadCUR_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a GIF image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedGIF :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadGIF_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a ICO image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedICO :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadICO_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a JPEG image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedJPEG :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadJPG_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a LBM image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedLBM :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadLBM_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a PCX image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedPCX :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadPCX_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a PNG image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedPNG :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadPNG_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a PNM image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedPNM :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadPNM_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a SVG image from an SVG code string
@param cxt the rendering context used to create the texture
@param data the string of SVG code
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedSVG :: proc(cxt: RenderContext, data: string) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadSVG_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a TGA image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedTGA :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadTGA_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a XCF image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedXCF :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadXCF_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a XPM image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedXPM :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadXPM_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a XV image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedXV :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadXV_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a WebP image from an array of bytes
@param cxt the rendering context used to create the texture
@param data the array of bytes to load
@return an SDL texture to pass to DrawTexture
*/
LoadEmbeddedWebP :: proc(cxt: RenderContext, data: []byte) -> ^Texture {
    rw := sdl2.RWFromConstMem(raw_data(data), cast(i32)size_of(data))
    if rw == nil { return nil }
    surf := image.LoadWEBP_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a BMP image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadBMPFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadBMP_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a CUR image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadCURFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadCUR_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a GIF image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadGIFFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadGIF_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a ICO image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadICOFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadICO_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a JPEG image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadJPEGFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadJPG_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a LBM image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadLBMFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadLBM_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a PCX image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadPCXFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadPCX_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a PNG image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadPNGFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadPNG_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a PNM image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadPNMFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadPNM_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a SVG image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadSVGFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadSVG_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a TGA image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadTGAFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadTGA_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a XCF image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadXCFFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadXCF_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a XPM image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadXPMFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadXPM_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a XV image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadXVFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadXV_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}

/*
loads a WebP image from a file
@param cxt the rendering context used to create the texture
@param file_path the path to the image file
@return an SDL texture to pass to DrawTexture
*/
LoadWebPFile :: proc(cxt: RenderContext, file_path: cstring) -> ^Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok { return nil }
    rw := sdl2.RWFromConstMem(&data, size_of(data))
    if rw == nil { return nil }
    surf := image.LoadWEBP_RW(rw)
    sdl2.FreeRW(rw)
    if surf == nil { return nil }
    tex := sdl2.CreateTextureFromSurface(cxt.Renderer, surf)
    sdl2.FreeSurface(surf)
    return tex
}


Animation :: image.Animation



LoadGIFAnimation :: proc(ctx: RenderContext, file_path: cstring) -> ^Animation {
    animation := image.LoadAnimation(file_path)

    if animation == nil {
        Util.Log(.ERROR, "MAGMA", "2D_RENDERER_LOAD_GIF_ANIMATION", "Could not load file: %s", file_path)
    }
    return animation
}

@(private)
AnimationCache :: struct {
	stopwatch:      time.Stopwatch,
	timeline_ends:  []f32,
	total_duration: f32,
	last_anim_ptr:  rawptr,
}

@(private)
anim_cache: AnimationCache

AnimationRender :: proc(ctx: ^RenderContext, anim: ^image.Animation) -> (current_surface: ^sdl2.Texture, loop_occurred: bool) {
	if anim == nil || anim.count <= 0 {
		return nil, false
	}

	loop_occurred = false

	if anim_cache.last_anim_ptr != rawptr(anim) {
		// Clean up old cache slice if it exists
		if anim_cache.timeline_ends != nil {
			delete(anim_cache.timeline_ends)
		}

		count := int(anim.count)
		anim_cache.timeline_ends = make([]f32, count)
		
		// Pre-calculate the exact timeline timestamps where each frame finishes
		running_sum: f32 = 0.0
		for i in 0..<count {
			running_sum += f32(anim.delays[i]) / 1000.0 // Convert ms to seconds
			anim_cache.timeline_ends[i] = running_sum
		}
		
		anim_cache.total_duration = running_sum
		anim_cache.last_anim_ptr = rawptr(anim)

		// Start/Reset the high precision stopwatch
		time.stopwatch_reset(&anim_cache.stopwatch)
		time.stopwatch_start(&anim_cache.stopwatch)
	}

	elapsed_seconds := f32(time.duration_seconds(time.stopwatch_duration(anim_cache.stopwatch)))

	// Guard against untimed or broken division states
	if anim_cache.total_duration <= 0.0 {
		return sdl2.CreateTextureFromSurface(ctx.Renderer, anim.frames[0]), false
	}

	// Handle timeline loop crossing safely without losing remainder precision
	if elapsed_seconds >= anim_cache.total_duration {
		loop_occurred = true
		
		// Modulo the time back down into a single loop duration window
		elapsed_seconds = math.mod(elapsed_seconds, anim_cache.total_duration)
		
		// Re-anchor stopwatch back to zero
		time.stopwatch_reset(&anim_cache.stopwatch)
		time.stopwatch_start(&anim_cache.stopwatch)
		
		// Wind the stopwatch forward by the remainder to preserve sub millisecond precision
		// This ensures lag spikes do not desynchronize animation
		remainder_duration := time.Duration(f64(elapsed_seconds) * f64(time.Second))
		anim_cache.stopwatch._accumulation += remainder_duration
	}

	target_idx := 0
	low := 0
	high := int(anim.count) - 1

	for low <= high {
		mid := low + (high - low) / 2
		if anim_cache.timeline_ends[mid] > elapsed_seconds {
			target_idx = mid
			high = mid - 1
		} else {
			low = mid + 1
		}
	}

	return sdl2.CreateTextureFromSurface(ctx.Renderer, anim.frames[target_idx]), loop_occurred
}

FreeAnimation :: proc(animation: ^Animation) {
    image.FreeAnimation(animation)
}