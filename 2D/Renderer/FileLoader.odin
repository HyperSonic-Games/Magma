package Renderer

import "core:os"
import "vendor:sdl2"
import "vendor:sdl2/image"
import "vendor:sdl2/ttf"

import "../../Util"

/*
Frees an SDL2 allocated texture
@param texture The texture to free
*/
UnloadTexture :: proc(texture: ^sdl2.Texture) {
    sdl2.DestroyTexture(texture)
}

/*
Loads a BMP image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedBMP :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a CUR image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedCUR :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a GIF image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedGIF :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a ICO image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedICO :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a JPEG image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedJPEG :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a LBM image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedLBM :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a PCX image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedPCX :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a PNG image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedPNG :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a PNM image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedPNM :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a SVG image from an SVG code string
@param cxt The rendering context used to create the texture
@param data The string of SVG code
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedSVG :: proc(cxt: RenderContext, data: string) -> ^sdl2.Texture {
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
Loads a TGA image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedTGA :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a XCF image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedXCF :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a XPM image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedXPM :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a XV image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedXV :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a WebP image from an array of bytes
@param cxt The rendering context used to create the texture
@param data The array of bytes to load
@return An SDL texture to pass to DrawTexture
*/
LoadEmbeddedWebP :: proc(cxt: RenderContext, data: []byte) -> ^sdl2.Texture {
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
Loads a BMP image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadBMPFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a CUR image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadCURFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a GIF image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadGIFFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a ICO image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadICOFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a JPEG image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadJPEGFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a LBM image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadLBMFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a PCX image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadPCXFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a PNG image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadPNGFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a PNM image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadPNMFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a SVG image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadSVGFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a TGA image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadTGAFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a XCF image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadXCFFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a XPM image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadXPMFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a XV image from a file
@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadXVFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
Loads a WebP image from a file

@param cxt The rendering context used to create the texture
@param file_path The path to the image file
@return An SDL texture to pass to DrawTexture
*/
LoadWebPFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
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
