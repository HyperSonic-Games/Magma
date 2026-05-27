"""
THIS IS MEANT TO BE USED WITH A TOOL AND NOT EDITED BY HAND
It is used to copy files like licenses and shared libs into the build dir
"""

RULES = [
    {
        "from": "sdl2/LICENSE.txt",
        "to": "licenses/SDL2/LICENSE.txt"
    },

    {
        "from": "sdl2/SDL2.dll",
        "to": "SDL2.dll",
        "os": "windows"
    },

    {
        "from": "sdl2/image/SDL2_image.dll",
        "to": "SDL2_image.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/image/libjpeg-9.dll",
        "to": "libjpeg-9.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/image/libpng16-16.dll",
        "to": "libpng16-16.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/image/libtiff-5.dll",
        "to": "libtiff-5.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/image/libwebp-7.dll",
        "to": "libwebp-7.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/image/zlib1.dll",
        "to": "zlib1.dll",
        "os": "windows"
    },

    {
        "from": "sdl2/image/LICENSE.txt",
        "to": "licenses/SDL2_image/LICENSE.txt"
    },
    {
        "from": "sdl2/image/LICENSE.jpeg.txt",
        "to": "licenses/SDL2_image/LICENSE.jpeg.txt"
    },
    {
        "from": "sdl2/image/LICENSE.png.txt",
        "to": "licenses/SDL2_image/LICENSE.png.txt"
    },
    {
        "from": "sdl2/image/LICENSE.tiff.txt",
        "to": "licenses/SDL2_image/LICENSE.tiff.txt"
    },
    {
        "from": "sdl2/image/LICENSE.webp.txt",
        "to": "licenses/SDL2_image/LICENSE.webp.txt"
    },
    {
        "from": "sdl2/image/LICENSE.zlib.txt",
        "to": "licenses/SDL2_image/LICENSE.zlib.txt"
    },

    {
        "from": "sdl2/mixer/SDL2_mixer.dll",
        "to": "SDL2_mixer.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libFLAC-8.dll",
        "to": "libFLAC-8.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libmodplug-1.dll",
        "to": "libmodplug-1.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libmpg123-0.dll",
        "to": "libmpg123-0.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libogg-0.dll",
        "to": "libogg-0.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libopus-0.dll",
        "to": "libopus-0.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libopusfile-0.dll",
        "to": "libopusfile-0.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libvorbis-0.dll",
        "to": "libvorbis-0.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/mixer/libvorbisfile-3.dll",
        "to": "libvorbisfile-3.dll",
        "os": "windows"
    },

    {
        "from": "sdl2/mixer/LICENSE.txt",
        "to": "licenses/SDL2_mixer/LICENSE.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.FLAC.txt",
        "to": "licenses/SDL2_mixer/LICENSE.FLAC.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.modplug.txt",
        "to": "licenses/SDL2_mixer/LICENSE.modplug.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.mpg123.txt",
        "to": "licenses/SDL2_mixer/LICENSE.mpg123.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.ogg-vorbis.txt",
        "to": "licenses/SDL2_mixer/LICENSE.ogg-vorbis.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.opus.txt",
        "to": "licenses/SDL2_mixer/LICENSE.opus.txt"
    },
    {
        "from": "sdl2/mixer/LICENSE.opusfile.txt",
        "to": "licenses/SDL2_mixer/LICENSE.opusfile.txt"
    },

    {
        "from": "sdl2/ttf/SDL2_ttf.dll",
        "to": "SDL2_ttf.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/ttf/libfreetype-6.dll",
        "to": "libfreetype-6.dll",
        "os": "windows"
    },
    {
        "from": "sdl2/ttf/zlib1.dll",
        "to": "zlib1.dll",
        "os": "windows"
    },

    {
        "from": "sdl2/ttf/COPYING.txt",
        "to": "licenses/SDL2_ttf/COPYING.txt"
    },
    {
        "from": "sdl2/ttf/LICENSE.freetype.txt",
        "to": "licenses/SDL2_ttf/LICENSE.freetype.txt"
    },
    {
        "from": "sdl2/ttf/LICENSE.zlib.txt",
        "to": "licenses/SDL2_ttf/LICENSE.zlib.txt"
    }
]