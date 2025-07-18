package Renderer

import bgfx "../../third_party/odin-bgfx"
import "vendor:sdl2"
import "../../Util"

RendererCTX :: struct {
    window: ^sdl2.Window,
    renderer: bgfx.Renderer_Type,
    width, height: u32,
}

Init :: proc(title: cstring, w, h: u32, fullscreen: bool = false, resizable: bool = true) -> Maybe(RendererCTX) {
	ctx := new(RendererCTX)
	ctx.width = w
	ctx.height = h
	ctx.renderer = .Vulkan

	if sdl2.Init({.VIDEO}) != 0 {
		free(ctx)
		Util.log(.ERROR, "Renderer3D", "SDL init failed: %s", sdl2.GetError())
		return nil
	}

	flags: sdl2.WindowFlags = {.SHOWN, .ALLOW_HIGHDPI, .VULKAN}
	if resizable {
        flags = flags | sdl2.WindowFlags{.RESIZABLE}
	}
	if fullscreen {
		flags = flags | sdl2.WindowFlags{.FULLSCREEN}
	}

	ctx.window = sdl2.CreateWindow(title, sdl2.WINDOWPOS_CENTERED, sdl2.WINDOWPOS_CENTERED, cast(i32)w, cast(i32)h, flags)
	if ctx.window == nil {
		free(ctx)
		Util.log(.ERROR, "Renderer3D", "SDL window creation failed: %s", sdl2.GetError())
		return nil
	}

	// Platform data
	wmi: sdl2.SysWMinfo
	sdl2.VERSION(&wmi.version)
	if sdl2.GetWindowWMInfo(ctx.window, &wmi) == false {
		free(ctx)
		Util.log(.ERROR, "Renderer3D", "SDL WM info failed: %s", sdl2.GetError())
		return nil
	}

	pd: bgfx.Platform_Data
	pd.ndt = nil
	pd.nwh = nil

	when ODIN_OS == .Windows {
		pd.nwh = wmi.info.win.window
	} else when ODIN_OS == .Linux {
		pd.ndt = wmi.info.x11.display
		pd.nwh = wmi.info.x11.window
	} else when ODIN_OS == .Darwin {
		pd.nwh = wmi.info.cocoa.window
	} else {
		Util.log(.ERROR, "Renderer3D", "Unsupported platform")
		return nil
	}

	bgfx.set_platform_data(pd)

	// Init BGFX
	init: bgfx.Init
	bgfx.init_ctor(&init)
	init.type = .Vulkan
	init.resolution.width = w
	init.resolution.height = h
	init.resolution.reset = bgfx.RESET_VSYNC

	if !bgfx.init(init) {
		Util.log(.ERROR, "Renderer3D", "BGFX init failed")
		return nil
	}

	return ctx^
}


Shutdown :: proc(ctx: ^RendererCTX) {
	if ctx == nil {
		return
	}

	bgfx.shutdown()

	if ctx.window != nil {
		sdl2.DestroyWindow(ctx.window)
		ctx.window = nil
	}

	sdl2.Quit()
	free(ctx)
}

