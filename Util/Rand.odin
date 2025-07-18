package Util

import "core:c/libc"

@init
SeedTheRand :: proc() {
    libc.srand(libc.uint32_t(libc.time(nil)))
}

RandomRange :: proc(min: int, max: int) -> int {
    return cast(int)(cast(i32)min + (libc.rand() % cast(i32)(max - min + 1)))
}
