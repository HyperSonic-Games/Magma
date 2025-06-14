package Util

import "core:compress/shoco"
import "core:strings"
import "core:os"


WriteCompressedStringFile :: proc(text: []string, filepath: string) {
    handle, _ := os.open(filepath, os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0o644)

    for line in text {
        compressed, _ := shoco.compress_string(line)
        os.write(handle, compressed)
    }

    os.close(handle)
}

ReadCompressedStringFile :: proc(filepath: string) -> []string {
    handle, _ := os.open(filepath, os.O_RDONLY)
    raw, ok := os.read_entire_file_from_handle(handle)
    os.close(handle)
    if !ok {
        return []string{}
    }

    result, _ := shoco.decompress_slice_to_string(raw)
    return strings.split(result, "\n")
}
