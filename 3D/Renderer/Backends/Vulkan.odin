package Backends

import "vendor:glfw"
import vk "vendor:vulkan"
import "base:runtime"
import "../../../Util"

// Vulkan API version being targeted
VK_API_VERSION :: vk.API_VERSION_1_2

// Converts window coordinates to Vulkan's flipped Y axis
VKXYFlipInt :: proc(#any_int x, #any_int y, #any_int window_height: int) -> (int, int) {
	return x, window_height - y
}

// Initializes GLFW for use with Vulkan backend
InitGLFWForVulkan :: proc() -> (ok: bool) {
	Util.log(.DEBUG, "Renderer3D_VK", "Using GLFW version: %s", glfw.GetVersionString())

	if glfw.Init() != true {
		Util.log(.ERROR, "Renderer3D_VK", "GLFW Init failed\nDescription: %s\nError Code: %d", glfw.GetError())
		glfw.Terminate()
		return false
	}

	// Vulkan doesn't even *use* OpenGL, but we still have to tell GLFW that
	// Because GLFW is annoying and wants to setup OpenGL for you anyway
	glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
	return true
}


// ┌────────────────────────────────────────────────────────────────────────────┐
// │ WHY I HATE VULKAN:                                                         │
// ├────────────────────────────────────────────────────────────────────────────┤
// │ - Verbose API for basic tasks.                                             │
// │ - You write 200 lines before drawing a triangle.                           │
// │ - Manual memory & queue family management is madness.                      │
// │ - Layers upon layers of structs, just to get a surface.                    │
// │ - Half of Vulkan is reinventing the GPU driver you're talking to.          │
// │ - The other half is writing code just to test if your first half works.    │
// │                                                                            │
// │                             +----------------+                             │
// │                             |   Vulkan API   |                             │
// │                             +--------+-------+                             │
// │                                      |                                     │
// │                                      v                                     │
// │                       +------------------------------+                     │
// │                       |     Boilerplate Hell Realm   | <- you are here     │
// │                       +------------------------------+                     │
// │                                      |                                     │
// │                                      v                                     │
// │                       +------------------------------+                     │
// │                       | 'Hello Triangle' (4 days in) |                     │
// │                       +------------------------------+                     │
// │                                                                            │
// │                  Meanwhile in OpenGL: glDrawArrays(...);  ← done           │
// └────────────────────────────────────────────────────────────────────────────┘

// Creates a Vulkan-compatible GLFW window, optionally fullscreen
CreateVulkanWindow :: proc(width, height: i32, title: cstring, fullscreen: bool) -> glfw.WindowHandle {
    width := width
    height := height
	monitor: glfw.MonitorHandle = nil
	if fullscreen {
		monitor = glfw.GetPrimaryMonitor()
		mode := glfw.GetVideoMode(monitor)
		width = mode.width
		height = mode.height
	}

	window := glfw.CreateWindow(width, height, title, monitor, nil)
	if window == nil {
		Util.log(.ERROR, "Renderer3D_VK", "Failed to create GLFW window")
	}
	return window
}

// Destroys the Vulkan window and cleans up GLFW
DestroyVulkanWindow :: proc(window: glfw.WindowHandle) {
	if window != nil {
		glfw.DestroyWindow(window)
	}
	glfw.Terminate()
}


// Vulkan rendering context information
VulkanContext :: struct {
	instance: vk.Instance,             // Vulkan instance (requires 8 structs just to get here)
	surface: vk.SurfaceKHR,            // Window surface (not obvious how you get this...)
	physical_device: vk.PhysicalDevice,// The GPU (good luck finding one that works)
	device: vk.Device,                 // Logical device (yes, you need another handle)
	graphics_queue: vk.Queue,          // For drawing stuff
	present_queue: vk.Queue,           // For showing it on screen (because one queue isn't enough)
}

// Initializes Vulkan context tied to a GLFW window
CreateVulkanContext :: proc(window: glfw.WindowHandle) -> (ok: bool, ctx: VulkanContext) {
	ctx = VulkanContext{}

	// Fill in application info (because Vulkan needs to know your life story)
	app_info := vk.ApplicationInfo{
		sType = vk.StructureType.APPLICATION_INFO,
		pApplicationName = "VulkanApp",
		applicationVersion = vk.MAKE_VERSION(1, 0, 0),
		pEngineName = "MAGMA_GAME_ENGINE",
		engineVersion = vk.MAKE_VERSION(1, 0, 0),
		apiVersion = VK_API_VERSION,
	}

	// Query extensions required by GLFW (yes, this is a requirement too)
	extensions := glfw.GetRequiredInstanceExtensions()
	inst_info := vk.InstanceCreateInfo{
		sType = vk.StructureType.INSTANCE_CREATE_INFO,
		pApplicationInfo = &app_info,
		enabledExtensionCount = u32(len(extensions)),
		ppEnabledExtensionNames = &extensions[0],
	}

	// Create Vulkan instance (pray this succeeds)
	if vk.CreateInstance(&inst_info, nil, &ctx.instance) != vk.Result.SUCCESS {
		Util.log(.ERROR, "Renderer3D_VK", "Failed to create Vulkan instance")
		return false, ctx
	}

	// Create a surface from the GLFW window (yet another function call)
	if glfw.CreateWindowSurface(ctx.instance, window, nil, &ctx.surface) != vk.Result.SUCCESS {
		Util.log(.ERROR, "Renderer3D_VK", "Failed to create Vulkan surface")
		return false, ctx
	}

	// Enumerate physical devices (aka: ask Vulkan "what GPU?" and get anxiety)
	count: u32
	vk.EnumeratePhysicalDevices(ctx.instance, &count, nil)
	if count == 0 {
		Util.log(.ERROR, "Renderer3D_VK", "No GPUs found")
		return false, ctx
	}
	devices := new([16]vk.PhysicalDevice)
	vk.EnumeratePhysicalDevices(ctx.instance, &count, &devices[0])

	// Loop over devices to find one with graphics and presentation support (sane default? nah)
	for i in 0..<int(count) {
		dev := devices[i]
		qcount: u32
		vk.GetPhysicalDeviceQueueFamilyProperties(dev, &qcount, nil)
		qprops := make([]vk.QueueFamilyProperties, qcount)
		vk.GetPhysicalDeviceQueueFamilyProperties(dev, &qcount, &qprops[0])

		// Find suitable queue family (this shouldn't be this hard)
		for j in 0..<int(qcount) {
            has_graphics := (qprops[j].queueFlags & vk.QueueFlags{.GRAPHICS}) != {}


			has_present := glfw.GetPhysicalDevicePresentationSupport(ctx.instance, dev, cast(u32)j) != 0

			if has_graphics && has_present {
				ctx.physical_device = dev

				// Create logical device (yes, we need a whole other struct for this too)
				prio : []f32 = {1.0}
				qinfo := vk.DeviceQueueCreateInfo{
					sType = vk.StructureType.DEVICE_QUEUE_CREATE_INFO,
					queueFamilyIndex = u32(j),
					queueCount = 1,
					pQueuePriorities = &prio[0],
				}
				dev_info := vk.DeviceCreateInfo{
					sType = vk.StructureType.DEVICE_CREATE_INFO,
					queueCreateInfoCount = 1,
					pQueueCreateInfos = &qinfo,
				}

				if vk.CreateDevice(dev, &dev_info, nil, &ctx.device) == vk.Result.SUCCESS {
					// Get graphics and presentation queue handles
					vk.GetDeviceQueue(ctx.device, u32(j), 0, &ctx.graphics_queue)
					ctx.present_queue = ctx.graphics_queue
					return true, ctx
				}
			}
		}
	}

	Util.log(.ERROR, "Renderer3D_VK", "No suitable GPU with graphics + present support")
	return false, ctx
}
