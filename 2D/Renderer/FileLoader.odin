package Renderer

import "core:os"
import "vendor:sdl2"
import "vendor:sdl2/image"
import stbrp "vendor:stb/rect_pack"
import stbv "vendor:stb/vorbis"

import "../../Util"

UnloadTexture :: proc(texture: ^sdl2.Texture) {
    sdl2.DestroyTexture(texture)
}

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
