package Util

import "core:compress/shoco"

// A shoco compressed string
CompressedString :: []u8

/*
 * CompressString compresses a string to save space in memory
 * this works best for English but will still work on other languages
 *
 * @param text The string to compress
 * @return The string after it has undergone compresion
 */
CompressString :: proc(text: string) -> CompressedString {
    compressed, _ := shoco.compress_string(text)
    return compressed
}

/*
 * UncompressString decompresses a CompressedString back to a normal string
 *
 * @param compressed_text The compressed string
 * @return The original string
 */
UncompressString :: proc(compressed_text: CompressedString) -> string {
    text, _ := shoco.decompress_slice_to_string(compressed_text)
    return text
}