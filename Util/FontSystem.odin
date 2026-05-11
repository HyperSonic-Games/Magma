package Util

import "vendor:sdl2/ttf"
import "core:container/xar"

FontType :: enum {
    NORMAL,
    BOLD,
    ITALIC,
    CUSTOM,
}

FontEntry :: struct {
    name: string,
    kind: FontType,
    size: i32,
    font: ^ttf.Font,
}

FontStorage :: struct {
    fonts: xar.Array(FontEntry, 4),

    Add: proc(
        storage: ^FontStorage,
        name: string,
        kind: FontType,
        path: string,
        size: i32,
    ) -> bool,

    Get: proc(
        storage: ^FontStorage,
        name: string,
        kind: FontType,
        size: i32,
    ) -> ^ttf.Font,
}

FontStorageCreate :: proc(capacity: int) -> ^FontStorage {

    storage := new(FontStorage)
    xar.init(&storage.fonts)
    return storage
}

FontStorageDelete :: proc(storage: ^FontStorage) {

    for i: int = 0; i < xar.len(storage.fonts); i += 1 {
        font := xar.array_get_ptr(&storage.fonts, i)
        ttf.CloseFont(font.font)
    }

    xar.array_destroy(&storage.fonts)
    free(storage)
}