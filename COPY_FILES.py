"""
THIS IS MEANT TO BE USED WITH A TOOL AND NOT EDITED BY HAND
It is used to copy files like licenses and shared libs into the build dir
"""

RULES = [
    {
        "from": "sdl2/LICENSE.txt",
        "to": "build/licenses/SDL2/LICENSE.txt"
    },

    {
        "from": "sdl2/SDL2.dll",
        "to": "build/SDL2.dll",
        "os": "windows"
    },

    {
        "from": "sdl2/image/SDL2_image.dll",
        "to": "build/SDL2_image.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/image/libjpeg-9.dll",
        "to": "build/libjpeg-9.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/image/libpng16-16.dll",
        "to": "build/libpng16-16.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/image/libtiff-5.dll",
        "to": "build/libtiff-5.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/image/libwebp-7.dll",
        "to": "build/libwebp-7.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/image/zlib1.dll",
        "to": "build/zlib1.dll",
        "os": "windows"
    },

    {
        "from": "sdl2/image/LICENSE.txt",
        "to": "build/licenses/SDL2_image/LICENSE.txt"
    },
    {
        "from": "sdl2/image/LICENSE.jpeg.txt",
        "to": "build/licenses/SDL2_image/LICENSE.jpeg.txt"
    },
    {
        "from": "sdl2/image/LICENSE.png.txt",
        "to": "build/licenses/SDL2_image/LICENSE.png.txt"
    },
    {
        "from": "sdl2/image/LICENSE.tiff.txt",
        "to": "build/licenses/SDL2_image/LICENSE.tiff.txt"
    },
    {
        "from": "sdl2/image/LICENSE.webp.txt",
        "to": "build/licenses/SDL2_image/LICENSE.webp.txt"
    },
    {
        "from": "sdl2/image/LICENSE.zlib.txt",
        "to": "build/licenses/SDL2_image/LICENSE.zlib.txt"
    },

    {
        "from": "sdl2/mixer/SDL2_mixer.dll",
        "to": "build/SDL2_mixer.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libFLAC-8.dll",
        "to": "build/libFLAC-8.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libmodplug-1.dll",
        "to": "build/libmodplug-1.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libmpg123-0.dll",
        "to": "build/libmpg123-0.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libogg-0.dll",
        "to": "build/libogg-0.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libopus-0.dll",
        "to": "build/libopus-0.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libopusfile-0.dll",
        "to": "build/libopusfile-0.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libvorbis-0.dll",
        "to": "build/libvorbis-0.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libvorbisfile-3.dll",
        "to": "build/libvorbisfile-3.dll",
        "os": "windows"
    },

    {
        "from": "sdl2/mixer/LICENSE.txt",
        "to": "build/licenses/SDL2_mixer/LICENSE.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.FLAC.txt",
        "to": "build/licenses/SDL2_mixer/LICENSE.FLAC.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.modplug.txt",
        "to": "build/licenses/SDL2_mixer/LICENSE.modplug.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.mpg123.txt",
        "to": "build/licenses/SDL2_mixer/LICENSE.mpg123.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.ogg-vorbis.txt",
        "to": "build/licenses/SDL2_mixer/LICENSE.ogg-vorbis.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.opus.txt",
        "to": "build/licenses/SDL2_mixer/LICENSE.opus.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.opusfile.txt",
        "to": "build/licenses/SDL2_mixer/LICENSE.opusfile.txt"
    },

    {
        "from": "sdl2/ttf/SDL2_ttf.dll",
        "to": "build/SDL2_ttf.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/ttf/libfreetype-6.dll",
        "to": "build/libfreetype-6.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/ttf/zlib1.dll",
        "to": "build/zlib1.dll",
        "os": "windows"
    },

    {
        "from": "sdl2/ttf/COPYING.txt",
        "to": "build/licenses/SDL2_ttf/COPYING.txt"
    },
    {
        "from": "sdl2/ttf/LICENSE.freetype.txt",
        "to": "build/licenses/SDL2_ttf/LICENSE.freetype.txt"
    },
    {
        "from": "sdl2/ttf/LICENSE.zlib.txt",
        "to": "build/licenses/SDL2_ttf/LICENSE.zlib.txt"
    }
]