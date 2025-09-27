package Util

import "core:compress/shoco"

CompressedString :: []u8

CompressString :: proc(text: string) -> CompressedString {
    compressed, _ := shoco.compress_string(text)
    return compressed
}

UncompressString :: proc(compressed_text: CompressedString) -> string {
    text, _ := shoco.decompress_slice_to_string(compressed_text)
    return text
}