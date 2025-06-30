package Util

import "core:strconv"
import "core:io"
import "core:compress/shoco"
import "core:encoding/csv"
import "core:encoding/base32"
import "core:encoding/base64"
import "core:strings"
import "core:os"


// WriteCompressedStringFile writes an array of strings to a file,
// compressing each line using Shoco compression before writing.
WriteCompressedStringFile :: proc(filepath: string, text: []string) {
    handle, _ := os.open(filepath, os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0o644)

    for line in text {
        compressed, _ := shoco.compress_string(line)
        os.write(handle, compressed)
    }

    os.close(handle)
}


// ReadCompressedStringFile reads a Shoco-compressed file,
// decompresses its content, and returns the result split by lines.
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


// ReadCSVFile reads and parses a CSV file into a flat array of all fields.
ReadCSVFile :: proc(filepath: string) -> []string {
    log(.DEBUG, "MAGMA_CSV_READER", "Reading CSV from file: %s", filepath)

    r: csv.Reader
    r.trim_leading_space = true
    defer csv.reader_destroy(&r)

    csv_data, ok := os.read_entire_file(filepath)
    if !ok {
        log(.ERROR, "MAGMA_CSV_READER", "Unable to open file: %s", filepath)
        return []string{}
    }
    defer delete(csv_data)

    csv.reader_init_with_string(&r, string(csv_data))
    log(.DEBUG, "MAGMA_CSV_READER", "CSV reader initialized")

    records, err := csv.read_all(&r)
    if err != nil {
        log(.ERROR, "MAGMA_CSV_READER", "Failed to parse CSV data in file: %s", filepath)
        return []string{}
    }
    log(.DEBUG, "MAGMA_CSV_READER", "Parsed %v records from CSV", len(records))

    // Use dynamic array
    dyn_result := make([dynamic]string)
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

    log(.DEBUG, "MAGMA_CSV_READER", "Returning %v fields from CSV", len(dyn_result))
    return dyn_result[:]
}


// WriteCSVFile writes a flat array of values as a single CSV line to a file.
WriteCSVFile :: proc(filepath: string, values: []string) -> (ok: bool) {
    log(.DEBUG, "MAGMA_CSV_WRITER", "Writing CSV to file: %s", filepath)
    builder := new(strings.Builder)
    builder = strings.builder_init(builder)
    i: int
    for i = 0; i < len(values); i += 1 {
        strings.write_string(builder, values[i])
        strings.write_string(builder, ",")
    }
    CSV_data := strings.to_string(builder^)

    file_handle, err := os.open(filepath, os.O_WRONLY)
    defer os.close(file_handle)
    if err != nil {
        log(.ERROR, "MAGMA_CSV_WRITER", "Unable to open file: %s", filepath)
        return false
    }

    os.write_string(file_handle, CSV_data)
    return true
}


// ReadBase32File reads a Base32-encoded file and decodes it into raw bytes.
ReadBase32File :: proc(filepath: string) -> []byte {
    file_handle, err := os.open(filepath, os.O_RDONLY)
    if err != nil {
        log(.ERROR, "MAGMA_BASE32_READER", "Unable to open file: %s", filepath)
        return nil
    }
    data, ok := os.read_entire_file_from_handle(file_handle)
    if !ok {
        log(.ERROR, "MAGMA_BASE32_READER", "Unable to read file: %s", filepath)
        return nil
    }
    decoded_data, err1 := base32.decode(cast(string)data)
    if err1 != nil {
        log(.ERROR, "MAGMA_BASE32_READER", "Unable to decode data: %v", data)
        return nil
    }
    return decoded_data
}


// WriteBase32File encodes the given data to Base32 and writes it to a file.
WriteBase32File :: proc(filepath: string, data: []byte) -> bool {
    encoded := base32.encode(data)
    defer delete(encoded)

    ok := os.write_entire_file(filepath, transmute([]byte)encoded)
    if !ok {
        log(.ERROR, "MAGMA_BASE32_WRITER", "Failed to write Base32 data to file: %s", filepath)
        return false
    }

    log(.DEBUG, "MAGMA_BASE32_WRITER", "Successfully wrote Base32 data to file: %s", filepath)
    return true
}


// ReadBase64File reads a Base64-encoded file and decodes it into raw bytes.
ReadBase64File :: proc(filepath: string) -> []byte {
    file_handle, err := os.open(filepath, os.O_RDONLY)
    if err != nil {
        log(.ERROR, "MAGMA_BASE64_READER", "Unable to open file: %s", filepath)
        return nil
    }
    data, ok := os.read_entire_file_from_handle(file_handle)
    if !ok {
        log(.ERROR, "MAGMA_BASE64_READER", "Unable to read file: %s", filepath)
        return nil
    }
    decoded_data, err1 := base64.decode(cast(string)data)
    if err1 != nil {
        log(.ERROR, "MAGMA_BASE64_READER", "Unable to decode Base64 data")
        return nil
    }
    return decoded_data
}


// WriteBase64File encodes the given data to Base64 and writes it to a file.
WriteBase64File :: proc(filepath: string, data: []byte) -> bool {
    encoded := base64.encode(data)
    defer delete(encoded)

    ok := os.write_entire_file(filepath, transmute([]byte)encoded)
    if !ok {
        log(.ERROR, "MAGMA_BASE64_WRITER", "Failed to write Base64 data to file: %s", filepath)
        return false
    }

    log(.DEBUG, "MAGMA_BASE64_WRITER", "Successfully wrote Base64 data to file: %s", filepath)
    return true
}
