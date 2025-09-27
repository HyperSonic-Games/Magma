package Util

import "core:strings"
import "core:c/libc"
import "core:hash"
import "core:encoding/uuid"

import "../Types"

@init
@private
SeedTheRand :: proc() {
    libc.srand(libc.uint32_t(libc.time(nil)))
}

/*
 * RandomRange Randomly Generates a number in a provided range
 *
 * @param max The max value of the range
 * @param min The min value of the range
 * @return a random int in the range of the two values
*/
RandomRange :: proc(min: int, max: int) -> int {
    return cast(int)(cast(i32)min + (libc.rand() % cast(i32)(max - min + 1)))
}


@private
HashUUID :: proc(id: uuid.Identifier) -> u16 {
    id := uuid.to_string(id)
    defer delete(id)

    id_list := transmute([]byte)id
    return hash.ginger16(id_list)
}

@private
UUIDToRGBA :: proc(id: uuid.Identifier) -> Types.Color {
    h := HashUUID(id)

    // Use hash bits to derive RGB deterministically
    r := cast(u8)((h >> 8) & 0xFF)
    g := cast(u8)(h & 0xFF)
    b := cast(u8)(((cast(u32)h * 2654435761) >> 24) & 0xFF) // mix high bits
    color: Types.Color = {r, g, b, 255}
    return color
}
/*
 * GenRandomColor Uses UUID version 4 to generate a random color
 * @return The randomly generated color
 */
GenRandomColor :: proc() -> Types.Color {
    return UUIDToRGBA(uuid.generate_v4())
}