package Util

import "core:compress/shoco"
import "core:encoding/csv"
import "core:encoding/base32"
import "core:encoding/base64"
import "core:dynlib"
import "core:strings"
import "core:os"

/*
 * WriteCompressedStringFile writes an array of strings to a file.
 * Each line is compressed using Shoco compression before being written.
 *
 * @param filepath Destination file path
 * @param text Array of strings to compress and write
*/
WriteCompressedStringFile :: proc(filepath: string, text: []string) {
    handle, _ := os.open(filepath, {.Write, .Create})

    for line in text {
        compressed, _ := shoco.compress_string(line)
        os.write(handle, compressed)
    }

    os.close(handle)
}

/*
 * ReadCompressedStringFile reads a Shoco-compressed file,
 * decompresses its content, and returns the result split by lines.
 *
 * @param filepath Path to the compressed file
 * @return Decompressed lines as an array of strings
*/
ReadCompressedStringFile :: proc(filepath: string, allocator := context.allocator) -> []string {
    handle, _ := os.open(filepath, os.O_RDONLY)
    raw, err := os.read_entire_file_from_file(handle, allocator)
    os.close(handle)
    if err != os.ERROR_NONE {
        return []string{}
    }

    result, _ := shoco.decompress_slice_to_string(raw, allocator = allocator)
    return strings.split(result, "\n", allocator)
}

/*
 * ReadCSVFile reads and parses a CSV file into a flat array of all fields.
 *
 * @param filepath Path to the CSV file
 * @return Flat array of all CSV fields
*/
ReadCSVFile :: proc(filepath: string, allocator := context.allocator) -> []string {
    log(.DEBUG, "MAGMA", "CSV_READER", "Reading CSV from file: %s", filepath)

    r: csv.Reader
    r.trim_leading_space = true
    defer csv.reader_destroy(&r)

    file, _ := os.open(filepath)
    csv_data, err := os.read_entire_file_from_file(file, allocator)
    os.close(file)
    if err != os.ERROR_NONE {
        log(.ERROR, "MAGMA", "CSV_READER", "Unable to open file: %s", filepath)
        return []string{}
    }
    defer delete(csv_data)

    csv.reader_init_with_string(&r, string(csv_data), allocator)
    log(.VERBOSE, "MAGMA", "CSV_READER", "CSV reader initialized")

    records, err1 := csv.read_all(&r, allocator)
    if err != os.ERROR_NONE {
        log(.ERROR, "MAGMA", "CSV_READER", "Failed to parse CSV data in file: %s", filepath)
        return []string{}
    }
    log(.DEBUG, "MAGMA", "CSV_READER", "Parsed %v records from CSV", len(records))

    dyn_result := make([dynamic]string, allocator)
    defer free(&dyn_result)
    for rec in records {
        for field in rec {
            append(&dyn_result, field)
        }
    }

    defer {
        for rec in records {
            delete(rec)
        }
        delete(records)
    }

    log(.VERBOSE, "MAGMA", "CSV_READER", "Returning %v fields from CSV", len(dyn_result))
    return dyn_result[:]
}

/*
 * WriteCSVFile writes a flat array of values as a single CSV line to a file.
 *
 * @param filepath File to write to
 * @param values Flat array of values to write
 * @return True if write succeeded
*/
WriteCSVFile :: proc(filepath: string, values: []string) -> (ok: bool) {
    log(.DEBUG, "MAGMA", "CSV_WRITER", "Writing CSV to file: %s", filepath)
    builder := new(strings.Builder)
    builder = strings.builder_init(builder)
    defer free(builder)
    i: int
    for i = 0; i < len(values); i += 1 {
        strings.write_string(builder, values[i])
        strings.write_string(builder, ",")
    }
    CSV_data := strings.to_string(builder^)

    file_handle, err := os.open(filepath, os.O_WRONLY)
    defer os.close(file_handle)
    if err != nil {
        log(.ERROR, "MAGMA", "CSV_WRITER", "Unable to open file: %s", filepath)
        return false
    }

    os.write_string(file_handle, CSV_data)
    return true
}

/*
* ReadBase32File reads a Base32-encoded file and decodes it into raw bytes.
*
* @param filepath Path to encoded file
* @return Decoded byte slice or nil on error
*/
ReadBase32File :: proc(filepath: string, allocator := context.allocator) -> []byte {
    file_handle, err := os.open(filepath, os.O_RDONLY)
    defer os.close(file_handle)
    if err != nil {
        log(.ERROR, "MAGMA", "BASE32_READER", "Unable to open file: %s", filepath)
        return nil
    }
    data, err1 := os.read_entire_file_from_file(file_handle, allocator)
    if err1 != os.ERROR_NONE {
        log(.ERROR, "MAGMA", "BASE32_READER", "Unable to read file: %s", filepath)
        return nil
    }
    decoded_data, err2 := base32.decode(cast(string)data, allocator = allocator)
    if err2 != nil {
        log(.ERROR, "MAGMA", "BASE32_READER", "Unable to decode data: %v", data)
        return nil
    }
    return decoded_data
}

/*
* WriteBase32File encodes the given data to Base32 and writes it to a file.
*
* @param filepath Destination file
* @param data Byte slice to encode
* @return True if write succeeded
*/
WriteBase32File :: proc(filepath: string, data: []byte) -> bool {
    encoded := base32.encode(data)
    defer delete(encoded)

    err := os.write_entire_file(filepath, transmute([]byte)encoded)
    if err != os.ERROR_NONE {
        log(.ERROR, "MAGMA", "BASE32_WRITER", "Failed to write Base32 data to file: %s", filepath)
        return false
    }

    log(.DEBUG, "MAGMA", "BASE32_WRITER", "Successfully wrote Base32 data to file: %s", filepath)
    return true
}

/*
* ReadBase64File reads a Base64-encoded file and decodes it into raw bytes.
*
* @param filepath Input file path
* @return Decoded byte slice or nil on error
*/
ReadBase64File :: proc(filepath: string, allocator := context.allocator) -> []byte {
    file_handle, err := os.open(filepath, os.O_RDONLY)
    defer os.close(file_handle)
    if err != os.ERROR_NONE {
        log(.ERROR, "MAGMA", "BASE64_READER", "Unable to open file: %s", filepath)
        return nil
    }
    data, err1 := os.read_entire_file_from_file(file_handle, allocator)
    if  err1 != os.ERROR_NONE {
        log(.ERROR, "MAGMA", "BASE64_READER", "Unable to read file: %s", filepath)
        return nil
    }
    decoded_data, err2 := base64.decode(cast(string)data, allocator = allocator)
    if err2 != nil {
        log(.ERROR, "MAGMA", "BASE64_READER", "Unable to decode Base64 data")
        return nil
    }
    return decoded_data
}

/*
* WriteBase64File encodes the given data to Base64 and writes it to a file.
*
* param: filepath Output file path
* @param data Byte slice to encode
* @return True if write succeeded
*/
WriteBase64File :: proc(filepath: string, data: []byte) -> bool {
    encoded := base64.encode(data)
    defer delete(encoded)

    err := os.write_entire_file(filepath, transmute([]byte)encoded)
    if err != os.ERROR_NONE {
        log(.ERROR, "MAGMA", "BASE64_WRITER", "Failed to write Base64 data to file: %s", filepath)
        return false
    }

    log(.DEBUG, "MAGMA", "BASE64_WRITER", "Successfully wrote Base64 data to file: %s", filepath)
    return true
}


// stores a reference to a loaded dynamic library.
DynamicLibHandle :: dynlib.Library

/*
 * LoadDynamicLibrary loads a dynamic library and resolves its symbols into a struct.
 *
 * @param filepath Path to the dynamic library
 * @param symbol_table Pointer to struct to receive function pointers
*/
LoadDynamicLibrary :: proc(filepath: string, symbol_table: ^$T) {
    when !intrinsics.type_is_struct(T) {
        #panic("symbol_table was expected to be a struct")
    }
    count, ok := dynlib.initialize_symbols(symbol_table, filepath)
    if !ok {
        log(.ERROR, "MAGMA", "DYNAMIC_LIBRARY_LOADER", "Failed to load dynamic library: %s", dynlib.last_error())
    } else {
        log(.DEBUG, "MAGMA", "DYNAMIC_LIBRARY_LOADER", "Loaded %d symbols", count)
    }
}

/*
 * UnloadDynamicLibrary unloads a previously loaded dynamic library.
 *
 * @param symbol_table Struct containing the dynamic library handle
*/
UnloadDynamicLibrary :: proc(symbol_table: $T) {
    when !intrinsics.type_is_struct(T) {
        #panic("symbol_table was expected to be a struct")
    }
    dynlib.unload_library(symbol_table.__handle)
}

/*
 * ReadGenericFile reads a file into buffer of bytes
 */
ReadGenericFile :: proc(path: string, allocator := context.allocator) -> (data: []byte, ok: bool) {
    file: ^os.File
    err: os.Error
    file, err = os.open(path)
    if err != os.ERROR_NONE {
        return nil, false
    }
    file_data: []byte
    file_data, err = os.read_entire_file_from_file(file, allocator)
    if err != os.ERROR_NONE {
        return nil, false
    }
    return file_data, true
}