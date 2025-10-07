About
=====

In 2023, we struggled to find the right game engine for our projects. We tried several options:

*   **Godot:** Simple GDscript and open-source, but cumbersome theme system and nested nodes.
*   **Unity:** Popular and easy to pick up, but licensing and workflow mismatched our needs.
*   **Unreal Engine:** Huge (~43 GiB), 3D-focused, and C++-heavy—unsuitable for rapid 2D prototyping.
*   **Pygame:** Simple API for 2D games, but limited performance and no built-in networking.

We needed a **lightweight, fast, and flexible engine**—thus, **Magma**.

*   **Magma:** Built on SDL2 for 2D rendering, with optional 3D via OpenGL (raylib) Includes custom networking with VOIP, TCP/UDP server-client, and P2P support.

Usage
-----

Magma compiles **alongside your game code**. We recommend using the SDK for the easiest setup:

### 1\. Using the SDK (Recommended)

The Magma SDK automatically creates a ready-to-build project:
```bash
python magma-sdk.py create <release-tag (optional, put 'none' for master)> <project-name> && cd <project-name>
```

This sets up a fully configured project with Magma linked. You can still edit the engine itself to extend or tweak functionality.

**Recommended:** Using the SDK is the easiest and most streamlined way to start a new project.

### 2\. Git Submodule (Advanced)

For full manual control, add Magma as a submodule:
```bash
git submodule add --recursive https://github.com/HyperSonic-Games/Magma Magma
git submodule update --init --recursive
```

This places Magma in your project folder for direct engine modifications.

Note **Windows** When using Magma from a git submodule: Copy the required SDL2 DLLs (SDL2.dll, SDL2_image.dll, SDL2_mixer.dll) and all other dependencies in the SDL2 folders from your Odin compiler's vendor folder to the folder containing your compiled program.