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

FontStorageInit :: proc(Storage: ^FontStorage, Allocator := context.allocator) {
	Storage.Fonts = make([dynamic]FontEntry, Allocator)
}

FontStorageDestroy :: proc(Storage: ^FontStorage) {
	for &Entry in Storage.Fonts {
		if Entry.Font != nil {
			ttf.CloseFont(Entry.Font)
		}
		if Entry.AtlasTexture != nil {
			sdl2.DestroyTexture(Entry.AtlasTexture)
		}
		delete(Entry.Glyphs)
		delete(Entry.Name)
	}
	delete(Storage.Fonts)
}

FontStorageAdd :: proc(
	Storage: ^FontStorage,
	SdlRenderer: ^sdl2.Renderer,
	Name: string,
	Kind: FontType,
	Path: string,
	Size: i32,
	AtlasSize: i32 = 1024,
) -> (bool, ^FontEntry) {

	if ttf.WasInit() == 0 {
		if ttf.Init() != 0 {
			return false, nil
		}
	}

	for &Entry in Storage.Fonts {
		if Entry.Name == Name && Entry.Kind == Kind && Entry.Size == Size {
			return true, &Entry
		}
	}
	CPath := strings.clone_to_cstring(Path, context.temp_allocator)
	RawFont := ttf.OpenFont(CPath, Size)
	if RawFont == nil {
		return false, nil
	}

	AtlasTex := sdl2.CreateTexture(SdlRenderer, .RGBA32, .STREAMING, AtlasSize, AtlasSize)
	if AtlasTex == nil {
		ttf.CloseFont(RawFont)
		return false, nil
	}
	sdl2.SetTextureBlendMode(AtlasTex, .BLEND)

	Pixels: ^byte
	Pitch: i32
	if sdl2.LockTexture(AtlasTex, nil, transmute(^rawptr)&Pixels, &Pitch) == 0 {
		mem.set(rawptr(Pixels), 0, int(Pitch * AtlasSize))
		sdl2.UnlockTexture(AtlasTex)
	}

	NewEntry: FontEntry
	NewEntry.Name = strings.clone(Name)
	NewEntry.Kind = Kind
	NewEntry.Size = Size
	NewEntry.Font = RawFont
	NewEntry.AtlasTexture = AtlasTex
	NewEntry.Glyphs = make(map[rune]GlyphInfo)
	NewEntry.LineHeight = ttf.FontHeight(RawFont)
	NewEntry.AtlasWidth = AtlasSize
	NewEntry.AtlasHeight = AtlasSize
	NewEntry.NextX = 2 // Small safety edge padding margins
	NewEntry.NextY = 2
	NewEntry.MaxRowHeight = 0

	append(&Storage.Fonts, NewEntry)
	return true, &Storage.Fonts[len(Storage.Fonts) - 1]
}

FontStorageGet :: proc(Storage: ^FontStorage, Name: string, Kind: FontType, Size: i32) -> ^FontEntry {
	if Storage == nil do return nil

	for &Entry in Storage.Fonts {
		if Entry.Name == Name && Entry.Kind == Kind && Entry.Size == Size {
			return &Entry
		}
	}

	return nil
}

EnsureGlyphCached :: proc(Font: ^FontEntry, SdlRenderer: ^sdl2.Renderer, R: rune) -> (GlyphInfo, bool) {
	if Font == nil || Font.AtlasTexture == nil {
		return {}, false
	}

	info, exists := Font.Glyphs[R]
	if exists {
		return info, true
    }

	MinX, MaxX, MinY, MaxY, Adv: i32
	if ttf.GlyphMetrics(Font.Font, u16(R), &MinX, &MaxX, &MinY, &MaxY, &Adv) != 0 {
		return {}, false
	}

	WhiteColor := sdl2.Color{255, 255, 255, 255}
	GlyphSurf := ttf.RenderGlyph_Blended(Font.Font, u16(R), WhiteColor)
	if GlyphSurf == nil {
		Info := GlyphInfo{AdvanceX = Adv}
		Font.Glyphs[R] = Info
		return Info, true
	}
	defer sdl2.FreeSurface(GlyphSurf)

	Pad := i32(2)
	W := GlyphSurf.w
	H := GlyphSurf.h

	if Font.NextX + W + Pad >= Font.AtlasWidth {
		Font.NextX = 2
		Font.NextY += Font.MaxRowHeight + Pad
		Font.MaxRowHeight = 0
	}

	if Font.NextY + H + Pad >= Font.AtlasHeight {
	    Log(
			.INFO,
			"MAGMA_ENGINE",
			"FONT_SYSTEM",
			"Font Atlas Texture completely full! Clearing runtime map cache lines."
		)
		clear(&Font.Glyphs)
		Font.NextX = 2
		Font.NextY = 2
		Font.MaxRowHeight = 0
		
		Pixels: ^byte
		Pitch: i32
		if sdl2.LockTexture(Font.AtlasTexture, nil, transmute(^rawptr)&Pixels, &Pitch) == 0 {
			mem.set(rawptr(Pixels), 0, int(Pitch * Font.AtlasHeight))
			sdl2.UnlockTexture(Font.AtlasTexture)
		}
	}
	SrcRect := sdl2.Rect{Font.NextX, Font.NextY, W, H}

	if sdl2.UpdateTexture(Font.AtlasTexture, &SrcRect, GlyphSurf.pixels, GlyphSurf.pitch) != 0 {
		return {}, false
	}

	if H > Font.MaxRowHeight do Font.MaxRowHeight = H
	Font.NextX += W + Pad

	Info := GlyphInfo{
		SrcRect = SrcRect,
		AdvanceX = Adv,
		MinX = MinX,
		MaxX = MaxX,
		MinY = MinY,
		MaxY = MaxY,
	}

	Font.Glyphs[R] = Info
	return Info, true
}

GetStringMetrics :: proc(Font: ^FontEntry, SdlRenderer: ^sdl2.Renderer, Text: string) -> Types.Vector2f {
	if Font == nil || len(Text) == 0 {
		 return {0, 0}
	}
	W: i32 = 0
	
	for r in Text {
		info, ok := EnsureGlyphCached(Font, SdlRenderer, r)
		if ok {
			W += info.AdvanceX
		}
	}
	return {f32(W), f32(Font.LineHeight)}
}
