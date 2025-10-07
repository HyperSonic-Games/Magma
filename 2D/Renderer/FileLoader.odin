package Renderer

import "core:os"
import "vendor:sdl2"
import "vendor:sdl2/image"
import "vendor:sdl2/ttf"

import "../../Util"



/*
 * UnloadTexture Frees an SDL2 allocated texture
 * @param texture The texture to free
 */
UnloadTexture :: proc(texture: ^sdl2.Texture) {
    sdl2.DestroyTexture(texture)
}

/*
 * LoadEmbeddedBMP Loads a BMP image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedCUR Loads a CUR image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedGIF Loads a GIF image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedICO Loads a ICO image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedJPEG Loads a JPEG image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedLBM Loads a LBM image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedPCX Loads a PCX image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedPNG Loads a PNG image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedPNM Loads a PNM image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedSVG Loads a SVG image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The string of SVG code
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedTGA Loads a TGA image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedXCF Loads a XCF image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedXPM Loads a XPM image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedXV Loads a XV image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadEmbeddedWebP Loads a WebP image from an array of bytes
 *
 * @param cxt The rendering context used to create the texture
 * @param data The array of bytes to load
 * @return An SDL texture to pass to DrawTexture
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
 * LoadBMPFile Loads a BMP image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadBMPFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_BMP_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadBMP_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadCURFile Loads a CUR image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadCURFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_CUR_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadCUR_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadGIFFile Loads a GIF image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadGIFFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_GIFF_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadGIF_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadICOFile Loads a ICO image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadICOFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_ICO_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadICO_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadJPEGFile Loads a JPEG image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadJPEGFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_JPEG_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadJPG_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadLBMFile Loads a LBM image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadLBMFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_LBM_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadLBM_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadPCXFile Loads a PCX image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadPCXFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_PCX_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadPCX_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadPNGFile Loads a PNG image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadPNGFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_PNG_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadPNG_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadPNMFile Loads a PNM image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadPNMFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_PNM_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadPNM_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadSVGFile Loads a SVG image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadSVGFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_SVG_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadSVG_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadTGAFile Loads a TGA image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadTGAFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_TGA_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadWEBP_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadXCFFile Loads a XCF image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadXCFFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_XCF_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadXCF_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadXMPFile Loads a XMP image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadXPMFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_XPM_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadXPM_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadXVFile Loads a XV image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadXVFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_XV_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadXV_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}

/*
 * LoadWebPFile Loads a WebP image from a file
 *
 * @param cxt The rendering context used to create the texture
 * @param file_path The path to the image file
 * @return An SDL texture to pass to DrawTexture
 */
LoadWebPFile :: proc(cxt: RenderContext, file_path: cstring) -> ^sdl2.Texture {
    data, ok := Util.ReadGenericFile(string(file_path))
    if !ok {
        Util.log(.ERROR, "MAGMA_RENDERER_2D_FILE_LOADER_WEBP_LOAD_FILE", "Could not open file at path: %s", file_path)
        return nil
    }
    image_rw := sdl2.RWFromConstMem(&data, size_of(data))
    image := image.LoadWEBP_RW(image_rw)
    sdl2.FreeRW(image_rw)
    return sdl2.CreateTextureFromSurface(cxt.Renderer, image)
}
