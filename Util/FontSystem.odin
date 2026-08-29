package Util

import "core:mem"
import "core:strings"
import "vendor:sdl2"
import "vendor:sdl2/ttf"
import "../Types"

FontType :: enum {
	Normal,
	Bold,
	Italic,
	Custom,
}

GlyphInfo :: struct {
	SrcRect: sdl2.Rect,
	AdvanceX: i32,
	MinX: i32, MaxX: i32,
	MinY: i32, MaxY: i32,
}

FontEntry :: struct {
	Name: string,
	Kind: FontType,
	Size: i32,
	Font: ^ttf.Font,
	AtlasTexture: ^sdl2.Texture,
	
	Glyphs: map[rune]GlyphInfo, 
	LineHeight: i32,
	
	AtlasWidth: i32,
	AtlasHeight: i32,
	NextX: i32,
	NextY: i32,
	MaxRowHeight: i32,
}

FontStorage :: struct {
	Fonts: [dynamic]FontEntry,
}

/*
creates a new storage for loaded fonts
@param storage a pointer to the storage to init
@param allocator the allocator used to allocate the storage
*/
FontStorageInit :: proc(storage: ^FontStorage, allocator := context.allocator) {
	storage.Fonts = make([dynamic]FontEntry, allocator)
}

/*
cleans up and frees the font storage
this does not invalidate the FontStorage pointer and
can be reinitalised with FontStorageInit
@param storage the pointer to the storage you want to destroy
*/
FontStorageDestroy :: proc(storage: ^FontStorage) {
	for &entry in storage.Fonts {
		if entry.Font != nil {
			ttf.CloseFont(entry.Font)
		}
		if entry.AtlasTexture != nil {
			sdl2.DestroyTexture(entry.AtlasTexture)
		}
		delete(entry.Glyphs)
		delete(entry.Name)
	}
	delete(storage.Fonts)
}

/*
loads and adds a font to storage
@param renderer the renderer used to manage the texture for normal use set it to Renderer.RenderContext.Renderer
@param storage the pointer to the storage to store the font to
@param name the name of the font used to identify it when rendering with it
@param kind the type of font
@param path the path to where the font's .ttf file is located
@param size the size of the text to load for this font
@param atlas_size the width and height of the atlas cache
@return true or false and the loaded font entry or nil
*/
FontStorageAdd :: proc(
	renderer: ^sdl2.Renderer,
	storage: ^FontStorage,
	name: string,
	kind: FontType,
	path: string,
	size: i32,
	atlas_size: i32 = 1024,
) -> (bool, ^FontEntry) {

	if ttf.WasInit() == 0 {
		if ttf.Init() != 0 {
			return false, nil
		}
	}

	for &entry in storage.Fonts {
		if entry.Name == name && entry.Kind == kind && entry.Size == size {
			return true, &entry
		}
	}
	c_path := strings.clone_to_cstring(path, context.temp_allocator)
	raw_font := ttf.OpenFont(c_path, size)
	if raw_font == nil {
		return false, nil
	}

	atlas_tex := sdl2.CreateTexture(renderer, .RGBA32, .STREAMING, atlas_size, atlas_size)
	if atlas_tex == nil {
		ttf.CloseFont(raw_font)
		return false, nil
	}
	sdl2.SetTextureBlendMode(atlas_tex, .BLEND)

	pixels: ^byte
	pitch: i32
	if sdl2.LockTexture(atlas_tex, nil, transmute(^rawptr)&pixels, &pitch) == 0 {
		mem.set(rawptr(pixels), 0, int(pitch * atlas_size))
		sdl2.UnlockTexture(atlas_tex)
	}

	new_entry: FontEntry
	new_entry.Name = strings.clone(name)
	new_entry.Kind = kind
	new_entry.Size = size
	new_entry.Font = raw_font
	new_entry.AtlasTexture = atlas_tex
	new_entry.Glyphs = make(map[rune]GlyphInfo)
	new_entry.LineHeight = ttf.FontHeight(raw_font)
	new_entry.AtlasWidth = atlas_size
	new_entry.AtlasHeight = atlas_size
	new_entry.NextX = 2 // Small safety edge padding margins
	new_entry.NextY = 2
	new_entry.MaxRowHeight = 0

	append(&storage.Fonts, new_entry)
	return true, &storage.Fonts[len(storage.Fonts) - 1]
}

/*
lookup and retrive a font from storage
@param storage a pointer to the storage to find the font from
@param name the name of the font to lookup
@param kind the kind of font to look up
@param size the size of font to look up
@return the font you searched for or nil on failure
*/
FontStorageGet :: proc(storage: ^FontStorage, name: string, kind: FontType, size: i32) -> ^FontEntry {
	if storage == nil {
		return nil
	}

	for &entry in storage.Fonts {
		if entry.Name == name && entry.Kind == kind && entry.Size == size {
			return &entry
		}
	}

	return nil
}

/*
internal function that checks if a glyph is cached
if the glyph is already cached, its cached information is returned
if it is not cached, the glyph is rendered and added to the atlas cache
if the atlas is full, the existing cache is cleared and the glyph is
added to the newly cleared atlas
@param font the font to check
@param glyph the glyph to check
@return the glyph information and true on success, or {} and false on failure
*/
EnsureGlyphCached :: proc(font: ^FontEntry, glyph: rune) -> (GlyphInfo, bool) {
	if font == nil || font.AtlasTexture == nil {
		return {}, false
	}

	info, exists := font.Glyphs[glyph]

	if exists {
		return info, true
	}

	min_x, max_x, min_y, max_y, adv: i32
	if ttf.GlyphMetrics(font.Font, cast(u16)glyph, &min_x, &max_x, &min_y, &max_y, &adv) != 0 {
		return {}, false
	}

	white_color := sdl2.Color{255, 255, 255, 255}
	GlyphSurf := ttf.RenderGlyph_Blended(font.Font, cast(u16)glyph, white_color)
	// Non renderable glyphs (e.g. space).
	if GlyphSurf == nil {
		Info := GlyphInfo{
			AdvanceX = adv,
			MinX = min_x,
			MaxX = max_x,
			MinY = min_y,
			MaxY = max_y,
		}

		font.Glyphs[glyph] = Info
		return Info, true
	}
	defer sdl2.FreeSurface(GlyphSurf)

	pad: i32 = 2
	w := GlyphSurf.w
	h := GlyphSurf.h

	// Nothing to upload.
	if w <= 0 || h <= 0 {
		Info := GlyphInfo{
			AdvanceX = adv,
			MinX = min_x,
			MaxX = max_x,
			MinY = min_y,
			MaxY = max_y,
		}

		font.Glyphs[glyph] = Info
		return Info, true
	}

	// Glyph can never fit in this atlas.
	if w + pad > font.AtlasWidth || h + pad > font.AtlasHeight {
		return {}, false
	}

	// Move to the next row if necessary.
	if font.NextX + w + pad > font.AtlasWidth {
		font.NextX = pad
		font.NextY += font.MaxRowHeight + pad
		font.MaxRowHeight = 0
	}

	// Not enough vertical space: invalidate the entire cache.
	if font.NextY + h + pad > font.AtlasHeight {
		Log(
			.INFO,
			"MAGMA_ENGINE",
			"FONT_SYSTEM",
			"Font Atlas Texture completely full! Clearing runtime map cache lines.",
		)

		clear(&font.Glyphs)

		font.NextX = pad
		font.NextY = pad
		font.MaxRowHeight = 0

		pixels: ^byte
		pitch: i32

		if sdl2.LockTexture(font.AtlasTexture, nil, transmute(^rawptr)&pixels, &pitch) == 0 {
			mem.set(rawptr(pixels), 0, int(pitch * font.AtlasHeight))
			sdl2.UnlockTexture(font.AtlasTexture)
		}
	}

	src_rect := sdl2.Rect{font.NextX, font.NextY, w, h}

	if sdl2.UpdateTexture(font.AtlasTexture, &src_rect,
		GlyphSurf.pixels,
		GlyphSurf.pitch,
	) != 0 {
		return {}, false
	}

	if h > font.MaxRowHeight {
		font.MaxRowHeight = h
	}

	font.NextX += w + pad

	Info := GlyphInfo{
		SrcRect = src_rect,
		AdvanceX = adv,
		MinX = min_x,
		MaxX = max_x,
		MinY = min_y,
		MaxY = max_y,
	}

	font.Glyphs[glyph] = Info

	return Info, true
}

GetStringMetrics :: proc(font: ^FontEntry, text: string) -> Types.Vector2f {
	if font == nil || len(text) == 0 {
		return {0, 0}
	}
	w: i32 = 0
	
	for r in text {
		info, ok := EnsureGlyphCached(font, r)
		if ok {
			w += info.AdvanceX
		}
	}
	return {cast(f32)w, cast(f32)font.LineHeight}
}
