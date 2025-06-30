package Backends


import gl "vendor:OpenGL"
import "vendor:glfw"
import "base:runtime"



import "../../../Util"


OpenGLDebugCallback :: proc "c" (source: uint, type: uint, id: uint, severity: uint, length: int, message: cstring, user_param: rawptr) {
	context = runtime.default_context()
    Util.log(.DEBUG, "Renderer3D_GL_Internal", "OpenGL Debug Message: %s", message)
}


GL_MAJOR_VERSION :: 4
GL_MINOR_VERSION :: 6






InitGLFWForOpenGL :: proc() -> (ok: bool) {
	Util.log(.DEBUG, "Renderer3D_GL", "Using GLFW version: %s", glfw.GetVersionString())

	glfw.InitHint(glfw.JOYSTICK_HAT_BUTTONS, 0)
	glfw.InitHint(glfw.COCOA_CHDIR_RESOURCES, 0)
	when ODIN_DEBUG {
		glfw.InitHint(glfw.CONTEXT_DEBUG, 1)
	}

	if !glfw.Init() {
		Util.log(.ERROR, "Renderer3D_GL", "GLFW Init has failed\nDescription: %s\nError Code: %d", glfw.GetError())
		glfw.Terminate()
		return false
	}
	return true
}

InitGL :: proc(width: i32, height: i32, title: cstring, fullscreen: bool) -> glfw.WindowHandle {
    width := width
    height := height
	if !InitGLFWForOpenGL() {
		return nil
	}

	// --- Window Hints ---
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, 1)
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.DOUBLEBUFFER, 1)

	when ODIN_DEBUG {
		glfw.WindowHint(glfw.OPENGL_DEBUG_CONTEXT, 1)
	}

	// --- Monitor for fullscreen ---
	monitor: glfw.MonitorHandle = nil
	if fullscreen {
		monitor = glfw.GetPrimaryMonitor()
		mode := glfw.GetVideoMode(monitor)
        width = mode.width
		height = mode.height
	}

	// --- Create Window ---
	window := glfw.CreateWindow(width, height, title, monitor, nil)
	if window == nil {
		Util.log(.ERROR, "Renderer3D_GL", "Failed to create GLFW window")
		glfw.Terminate()
		return nil
	}

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1) // Enable vsync


	when ODIN_DEBUG {
		if gl.DebugMessageCallback != nil {
			gl.Enable(gl.DEBUG_OUTPUT)
			gl.Enable(gl.DEBUG_OUTPUT_SYNCHRONOUS)
			gl.DebugMessageCallback(OpenGLDebugCallback, nil)
			gl.DebugMessageControl(gl.DONT_CARE, gl.DONT_CARE, gl.DONT_CARE, 0, nil, true)
			Util.log(.INFO, "OpenGL", "Debug message callback enabled.")
		} else {
			Util.log(.WARN, "OpenGL", "Debug message callback not available.")
		}
	}

	Util.log(.INFO, "Renderer3D_GL", "OpenGL Vendor:   %s", gl.GetString(gl.VENDOR))
	Util.log(.INFO, "Renderer3D_GL", "OpenGL Renderer: %s", gl.GetString(gl.RENDERER))
	Util.log(.INFO, "Renderer3D_GL", "OpenGL Version:  %s", gl.GetString(gl.VERSION))

	return window
}

DestroyGLFWForOpenGL :: proc(window: glfw.WindowHandle) {
	if window != nil {
		glfw.MakeContextCurrent(nil) // Unbind context
		glfw.DestroyWindow(window)
	}
	glfw.Terminate()
	Util.log(.INFO, "Renderer3D_GL", "OpenGL context unbound and GLFW terminated.")
}
