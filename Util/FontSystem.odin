package Util

import "core:strings"
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

FontStorageCreate :: proc() -> ^FontStorage {
	storage := new(FontStorage)
    storage.Add = Add
    storage.Get = Get
	xar.init(&storage.fonts)
	return storage
}

FontStorageDelete :: proc(storage: ^FontStorage) {

	for i := 0; i < xar.len(storage.fonts); i += 1 {
		font := xar.array_get_ptr(&storage.fonts, i)

		if font.font != nil {
			ttf.CloseFont(font.font)
			font.font = nil
		}
	}

	xar.array_destroy(&storage.fonts)
	free(storage)
}

@(private)
Add :: proc(
	storage: ^FontStorage,
	name: string,
	kind: FontType,
	path: string,
	size: i32,
) -> bool {

    if ttf.WasInit() == 0 {
        if ttf.Init() != 0 {
            Log(.ERROR, "MAGMA_ENGINE", "2D_RENDERER_RENDER_TEXT_TO_TEXTURE", "Could not init SDL2_ttf")
        }
	}

	for i := 0; i < xar.len(storage.fonts); i += 1 {
		entry := xar.array_get_ptr(&storage.fonts, i)

		if entry.name == name &&
		   entry.kind == kind &&
		   entry.size == size {

			// already exists, do nothing
			return true
		}
	}

	font := ttf.OpenFont(strings.clone_to_cstring(path, context.temp_allocator), size)
	if font == nil {
		return false
	}

	entry := FontEntry{
		name = name,
		kind = kind,
		size = size,
		font = font,
	}

	xar.push_back(&storage.fonts, entry)
	return true
}

@(private)
Get :: proc(
	storage: ^FontStorage,
	name: string,
	kind: FontType,
	size: i32,
) -> ^ttf.Font {

	for i := 0; i < xar.len(storage.fonts); i += 1 {
		entry := xar.array_get_ptr(&storage.fonts, i)

		if entry.name == name &&
		   entry.kind == kind &&
		   entry.size == size {

			return entry.font
		}
	}

	return nil
}
