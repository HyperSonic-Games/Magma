package Physics

import "core:math"
import "core:math/rand"
import "core:math/cmplx"
import "core:math/linalg"


Clamp :: proc(x, min, max: $T) -> T {
    if x < min do return min
    if x > max do return max
    return x
}

LerpF32 :: proc(a, b, t: $T) -> T {
    return a + (b - a) * t
}

Abs :: proc(x: $T) -> T {
    if x < 0 do return -x
    return x
}
