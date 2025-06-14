package Types

import "core:simd"

Vector2f :: #simd[2]f64
Vector2  :: #simd[2]i64
Vector3f :: [3]f64
Vector3  :: [3]i64
Vector4f :: #simd[4]f64
Vector4  :: #simd[4]i64

Vector2GetX :: proc (vec: Vector2) -> i64 {
    result: i64 = simd.extract(vec, 0)
    return result
}

Vector2GetY :: proc (vec: Vector2) -> i64 {
    result: i64 = simd.extract(vec, 1)
    return result
}

Vector2fGetX :: proc (vec: Vector2f) -> f64 {
    result: f64 = simd.extract(vec, 0)
    return result
}

Vector2fGetY :: proc (vec: Vector2f) -> f64 {
    result: f64 = simd.extract(vec, 1)
    return result
}


VectorAdd_Vector2 :: proc(a, b: Vector2) -> Vector2 {
    return simd.add(a, b)
}

VectorAdd_Vector2f :: proc(a, b: Vector2f) -> Vector2f {
    return simd.add(a, b)
}

VectorSub_Vector2 :: proc(a, b: Vector2) -> Vector2 {
    return simd.sub(a, b)
}

VectorSub_Vector2f :: proc(a, b: Vector2f) -> Vector2f {
    return simd.sub(a, b)
}

VectorMul_Vector2 :: proc(a, b: Vector2) -> Vector2 {
    return simd.mul(a, b)
}

VectorMul_Vector2f :: proc(a, b: Vector2f) -> Vector2f {
    return simd.mul(a, b)
}

VectorDiv_Vector2 :: proc(a, b: Vector2) -> Vector2 {
    return cast(#simd[2]i64)simd.div(cast(#simd[2]f64)a, cast(#simd[2]f64)b)
}

VectorDiv_Vector2f :: proc(a, b: Vector2f) -> Vector2f {
    return simd.div(a, b)
}


Vector3GetX :: proc (vec: Vector3) -> i64 {
    return vec[0]
}

Vector3fGetX :: proc (vec: Vector3f) -> f64 {
    return vec[0]
}

Vector3GetY :: proc (vec: Vector3) -> i64 {
    return vec[1]
}

Vector3fGetY :: proc (vec: Vector3f) -> f64 {
    return vec[1]
}

Vector3GetZ :: proc (vec: Vector3) -> i64 {
    return vec[2]
}

Vector3fGetZ :: proc (vec: Vector3f) -> f64 {
    return vec[2]
}


VectorAdd_Vector3 :: proc(a, b: Vector3) -> Vector3 {
    return Vector3{
        a[0] + b[0],
        a[1] + b[1],
        a[2] + b[2],
    }
}

VectorAdd_Vector3f :: proc(a, b: Vector3f) -> Vector3f {
    return Vector3f{
        a[0] + b[0],
        a[1] + b[1],
        a[2] + b[2],
    }
}

VectorSub_Vector3 :: proc(a, b: Vector3) -> Vector3 {
    return Vector3{
        a[0] - b[0],
        a[1] - b[1],
        a[2] - b[2],
    }
}

VectorSub_Vector3f :: proc(a, b: Vector3f) -> Vector3f {
    return Vector3f{
        a[0] - b[0],
        a[1] - b[1],
        a[2] - b[2],
    }
}

VectorMul_Vector3 :: proc(a, b: Vector3) -> Vector3 {
    return Vector3{
        a[0] * b[0],
        a[1] * b[1],
        a[2] * b[2],
    }
}

VectorMul_Vector3f :: proc(a, b: Vector3f) -> Vector3f {
    return Vector3f{
        a[0] * b[0],
        a[1] * b[1],
        a[2] * b[2],
    }
}

VectorDiv_Vector3 :: proc(a, b: Vector3) -> Vector3 {
    return Vector3{
        a[0] / b[0],
        a[1] / b[1],
        a[2] / b[2],
    }
}

VectorDiv_Vector3f :: proc(a, b: Vector3f) -> Vector3f {
    return Vector3f{
        a[0] / b[0],
        a[1] / b[1],
        a[2] / b[2],
    }
}


Vector4GetX :: proc (vec: Vector4) -> i64 {
    result: i64 = simd.extract(vec, 0)
    return result
}

Vector4GetY :: proc (vec: Vector4) -> i64 {
    result: i64 = simd.extract(vec, 1)
    return result
}

Vector4GetZ :: proc (vec: Vector4) -> i64 {
    result: i64 = simd.extract(vec, 2)
    return result
}

Vector4GetW :: proc (vec: Vector4) -> i64 {
    result: i64 = simd.extract(vec, 3)
    return result
}

Vector4fGetX :: proc (vec: Vector4f) -> f64 {
    result: f64 = simd.extract(vec, 0)
    return result
}

Vector4fGetY :: proc (vec: Vector4f) -> f64 {
    result: f64 = simd.extract(vec, 1)
    return result
}
Vector4fGetZ :: proc (vec: Vector4f) -> f64 {
    result: f64 = simd.extract(vec, 2)
    return result
}
Vector4fGetW :: proc (vec: Vector4f) -> f64 {
    result: f64 = simd.extract(vec, 3)
    return result
}

VectorAdd_Vector4 :: proc(a, b: Vector4) -> Vector4 {
    return simd.add(a, b)
}

VectorAdd_Vector4f :: proc(a, b: Vector4f) -> Vector4f {
    return simd.add(a, b)
}


VectorSub_Vector4 :: proc(a, b: Vector4) -> Vector4 {
    return simd.sub(a, b)
}

VectorSub_Vector4f :: proc(a, b: Vector4f) -> Vector4f {
    return simd.sub(a, b)
}

VectorMul_Vector4 :: proc(a, b: Vector4) -> Vector4 {
    return simd.mul(a, b)
}

VectorMul_Vector4f :: proc(a, b: Vector4f) -> Vector4f {
    return simd.mul(a, b)
}

VectorDiv_Vector4 :: proc(a, b: Vector4) -> Vector4 {
    return cast(#simd[4]i64)simd.div(cast(#simd[4]f64)a, cast(#simd[4]f64)b)
}

VectorDiv_Vector4f :: proc(a, b: Vector4f) -> Vector4f {
    return simd.div(a, b)
}

VectorAdd :: proc {
	VectorAdd_Vector2,
	VectorAdd_Vector2f,
	VectorAdd_Vector3,
	VectorAdd_Vector3f,
	VectorAdd_Vector4,
	VectorAdd_Vector4f,
}

VectorSub :: proc {
	VectorSub_Vector2,
	VectorSub_Vector2f,
	VectorSub_Vector3,
	VectorSub_Vector3f,
	VectorSub_Vector4,
	VectorSub_Vector4f,
}

VectorMul :: proc {
	VectorMul_Vector2,
	VectorMul_Vector2f,
	VectorMul_Vector3,
	VectorMul_Vector3f,
	VectorMul_Vector4,
	VectorMul_Vector4f,
}

VectorDiv :: proc {
	VectorDiv_Vector2,
	VectorDiv_Vector2f,
	VectorDiv_Vector3,
	VectorDiv_Vector3f,
	VectorDiv_Vector4,
	VectorDiv_Vector4f,
}