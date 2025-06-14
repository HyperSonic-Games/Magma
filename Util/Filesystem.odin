package Util

import "core:compress/shoco"
import "core:strings"
import "core:os"


ReadCompressedStringFile :: proc(filepath: string) -> []string {
    handle, err := os.open(filepath, os.O_RDONLY)
    if err != os.ERROR_NONE {
        file_contents, ok := os.read_entire_file_from_handle(handle)
        os.close(handle)
        if ok {
            decompressed, _ := shoco.decompress_slice_to_string(file_contents)
            return strings.split(decompressed, "\n")
        }
    }
    os.close(handle)
    return []string{}
}

WriteCompressedStringFile :: proc(filepath: string, data: []string) {
    handle, err := os.open(filepath, os.O_WRONLY | os.O_TRUNC)
    if err != os.ERROR_NONE {
        full_text := strings.join(data, "\n")
        compressed, _ := shoco.compress_string(full_text)
        os.write(handle, compressed)
        os.close(handle)
    } else {
        os.close(handle)
    }
}