# About
Around 2023, we faced a challenge: finding the right game engine for our projects. We tried multiple engines:

* Godot: It was good in some ways but bad in others. Its GDscript made writing code simple, and being open source meant we could fork it or see how things worked. However, its theme system was a headache, and the deeply nested node system was often confusing.

* Unity: Being popular and well-established was a plus—most people could pick it up quickly. But for our purposes, it didn’t fit well, and the licensing terms were a dealbreaker.

* Unreal Engine: Huge engine (about 43 GiB) mainly for 3D games. Its size and focus on 3D made it unsuitable for the 2D games we wanted to make. Plus, it uses C++, which wasn’t ideal for rapid prototyping.

* Pygame: We loved the simplicity of its API and how easy it was to prototype in Python. It was great for small 2D games but not performant enough for larger projects, limiting our creativity. The lack of built-in networking meant we often had to reinvent the wheel.

  From these experiences, we realized the need for a lightweight, fast, and flexible engine designed to suit our workflow—hence, Magma.

* Magma: Built from the ground up and leveraging the excellent SDL2 library for 2D rendering and BGFX for cross-GPU 3D rendering, Magma includes a custom, game-optimized networking system. It supports VOIP, TCP and UDP server/client architectures, TCP and UDP P2P, and raw socket send/receive functionality—all built to make networking and multiplayer development straightforward and efficient.

# Usage

Magma is designed to compile alongside your game code, giving you full control over the engine. You can set it up in two ways:

1. Using Git Submodule

   Add Magma to your project as a submodule and initialize it recursively:

   `git submodule add --recursive <Magma-repo-URL> Magma`


   `git submodule update --init --recursive`
   
   This includes Magma in your project folder, so you can modify the engine code directly if you need custom features.


2. Using the SDK
    
    The Magma SDK can automatically create a new project with everything configured:
    
    `./magma-sdk create <project-name> && cd <project-name>`
    
    This sets up a ready-to-build project with Magma linked. Since the engine compiles alongside your code, you can edit the engine itself whenever you need to extend or tweak functionality.