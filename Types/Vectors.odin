package Types

Vector2f :: [2]f32
Vector2d :: [2]f64
Vector2 :: [2]i32
Vector2w :: [2]i64

Vector3f :: [3]f32
Vector3d :: [3]f64
Vector3 :: [3]i32
Vector3w :: [3]i64

Vector4f :: [4]f32
Vector4d :: [4]f64
Vector4 :: [4]i32
Vector4w :: [4]i64

Vector2fMiddlePoint :: #force_inline proc(vec: Vector2f) -> Vector2f {
    return vec / 2.0
}

Vector2dMiddlePoint :: #force_inline proc(vec: Vector2d) -> Vector2d {
    return vec / 2.0
}

Vector2MiddlePoint :: #force_inline proc(vec: Vector2) -> Vector2 {
    return vec / 2.0
}

Vector2wMiddlePoint :: #force_inline proc(vec: Vector2w) -> Vector2w {
    return vec / 2.0
}

Vector3fMiddlePoint :: #force_inline proc(vec: Vector3f) -> Vector3f {
    return vec / 2.0
}

Vector3dMiddlePoint :: #force_inline proc(vec: Vector3d) -> Vector3d {
    return vec / 2.0
}

Vector3MiddlePoint :: #force_inline proc(vec: Vector3) -> Vector3 {
    return vec / 2.0
}

Vector3wMiddlePoint :: #force_inline proc(vec: Vector3w) -> Vector3w {
    return vec / 2.0
}

Vector4fMiddlePoint :: #force_inline proc(vec: Vector4f) -> Vector4f {
    return vec / 2.0
}

Vector4dMiddlePoint :: #force_inline proc(vec: Vector4d) -> Vector4d {
    return vec / 2.0
}

Vector4MiddlePoint :: #force_inline proc(vec: Vector4) -> Vector4 {
    return vec / 2.0
}

Vector4wMiddlePoint :: #force_inline proc(vec: Vector4w) -> Vector4w {
    return vec / 2.0
}

VectorMiddlePoint :: proc {
    Vector2fMiddlePoint,
    Vector2dMiddlePoint,
    Vector2MiddlePoint,
    Vector2wMiddlePoint,
    Vector3fMiddlePoint,
    Vector3dMiddlePoint,
    Vector3MiddlePoint,
    Vector3wMiddlePoint,
    Vector4fMiddlePoint,
    Vector4dMiddlePoint,
    Vector4MiddlePoint,
    Vector4wMiddlePoint,
}