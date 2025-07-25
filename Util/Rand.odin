package Util

import "core:c/libc"

@init
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
