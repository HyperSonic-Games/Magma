package Types

import "core:simd"


Vector2f :: #simd[2]f64
Vector2  :: #simd[2]i64
Vector3f :: [3]f64
Vector3  :: [3]i64
Vector4f :: #simd[4]f64
Vector4  :: #simd[4]i64

/*
 * Vector2GetX returns the x value of a 2D int vector
 *
 *
 * @param vec The vector to read x from
 * @return the x value
*/
Vector2GetX :: proc (vec: Vector2) -> i64 {
    result: i64 = simd.extract(vec, 0)
    return result
}

/*
 * Vector2GetY returns the y value of a 2D int vector
 *
 *
 * @param vec The vector to read y from
 * @return the y value
*/
Vector2GetY :: proc (vec: Vector2) -> i64 {
    result: i64 = simd.extract(vec, 1)
    return result
}

/*
 * Vector2fGetX returns the x value of a 2D float vector
 *
 *
 * @param vec The vector to read x from
 * @return the x value
*/
Vector2fGetX :: proc (vec: Vector2f) -> f64 {
    result: f64 = simd.extract(vec, 0)
    return result
}

/*
 * Vector2fGetY returns the y value of a 2D float vector
 *
 *
 * @param vec The vector to read y from
 * @return the y value
*/
Vector2fGetY :: proc (vec: Vector2f) -> f64 {
    result: f64 = simd.extract(vec, 1)
    return result
}

/*
 * Vector2SetX sets the x value of a 2D int vector
 *
 *
 * @param vec the vector to edit x from
 * @param x the x value
 * @return the new vector data
*/
Vector2SetX :: proc(vec: Vector2, x: i64) -> Vector2 {
    return simd.replace(vec, 0, x)
}

/*
 * Vector2SetY sets the y value of a 2D int vector
 *
 *
 * @param vec the vector to edit y from
 * @param y the y value
 * @return the new vector data
*/
Vector2SetY :: proc(vec: Vector2, y: i64) -> Vector2 {
    return simd.replace(vec, 1, y)
}

/*
 * Vector2fSetX sets the x value of a 2D float vector
 *
 *
 * @param vec the vector to edit x from
 * @param x the x value
 * @return the new vector data
*/
Vector2fSetX :: proc(vec: Vector2f, x: f64) -> Vector2f {
    return simd.replace(vec, 0, x)
}

/*
 * Vector2fSetY sets the y value of a 2D float vector
 *
 *
 * @param vec the vector to edit y from
 * @param y the y value
 * @return the new vector data
*/
Vector2fSetY :: proc(vec: Vector2f, y: f64) -> Vector2f {
    return simd.replace(vec, 1, y)
}


/*
 * VectorAdd_Vector2 adds two int 2D vectors together
 *
 *
 * @param a a vector to add
 * @param b a vector to add
 * @return the new vector data
*/
VectorAdd_Vector2 :: proc(a, b: Vector2) -> Vector2 {
    return simd.add(a, b)
}

/*
 * VectorAdd_Vector2f adds two float 2D vectors together
 *
 *
 * @param a a vector to add
 * @param b a vector to add
 * @return the new vector data
*/
VectorAdd_Vector2f :: proc(a, b: Vector2f) -> Vector2f {
    return simd.add(a, b)
}

/*
 * VectorSub_Vector2 subtracts two int 2D vectors together
 *
 *
 * @param a a vector to subtract
 * @param b a vector to subtract
 * @return the new vector data
*/
VectorSub_Vector2 :: proc(a, b: Vector2) -> Vector2 {
    return simd.sub(a, b)
}

/*
 * VectorSub_Vector2f subtracts two float 2D vectors together
 *
 *
 * @param a a vector to subtract
 * @param b a vector to subtract
 * @return the new vector data
*/
VectorSub_Vector2f :: proc(a, b: Vector2f) -> Vector2f {
    return simd.sub(a, b)
}

/*
 * VectorMul_Vector2 multiplys two int 2D vectors together
 *
 *
 * @param a a vector to multiply
 * @param b a vector to multiply
 * @return the new vector data
*/
VectorMul_Vector2 :: proc(a, b: Vector2) -> Vector2 {
    return simd.mul(a, b)
}

/*
 * VectorMul_Vector2f multiplys two float 2D vectors together
 *
 *
 * @param a a vector to multiply
 * @param b a vector to multiply
 * @return the new vector data
*/
VectorMul_Vector2f :: proc(a, b: Vector2f) -> Vector2f {
    return simd.mul(a, b)
}

/*
 * VectorDiv_Vector2 divides two int 2D vectors together
 *
 *
 * @param a a vector to divide
 * @param b a vector to divide
 * @return the new vector data
*/
VectorDiv_Vector2 :: proc(a, b: Vector2) -> Vector2 {
    return cast(#simd[2]i64)simd.div(cast(#simd[2]f64)a, cast(#simd[2]f64)b)
}

/*
 * VectorDiv_Vector2f divides two float 2D vectors together
 *
 *
 * @param a a vector to divide
 * @param b a vector to divide
 * @return the new vector data
*/
VectorDiv_Vector2f :: proc(a, b: Vector2f) -> Vector2f {
    return simd.div(a, b)
}

/*
 * Vector3GetX returns the x value of a 3D int vector
 *
 *
 * @param vec The vector to read y from
 * @return the y value
*/
Vector3GetX :: proc (vec: Vector3) -> i64 {
    return vec[0]
}

/*
 * Vector3fGetX returns the x value of a 3D float vector
 *
 *
 * @param vec The vector to read y from
 * @return the y value
*/
Vector3fGetX :: proc (vec: Vector3f) -> f64 {
    return vec[0]
}

/*
 * Vector3GetY returns the y value of a 3D int vector
 *
 *
 * @param vec The vector to read y from
 * @return the y value
*/
Vector3GetY :: proc (vec: Vector3) -> i64 {
    return vec[1]
}

/*
 * Vector3fGetY returns the y value of a 3D float vector
 *
 *
 * @param vec The vector to read y from
 * @return the y value
*/
Vector3fGetY :: proc (vec: Vector3f) -> f64 {
    return vec[1]
}

/*
 * Vector3GetZ returns the z value of a 3D int vector
 *
 *
 * @param vec The vector to read z from
 * @return the z value
*/
Vector3GetZ :: proc (vec: Vector3) -> i64 {
    return vec[2]
}

/*
 * Vector3fGetZ returns the z value of a 3D float vector
 *
 *
 * @param vec The vector to read z from
 * @return the z value
*/
Vector3fGetZ :: proc (vec: Vector3f) -> f64 {
    return vec[2]
}

/*
 * Vector3SetX sets the x value of a 3D int vector
 *
 *
 * @param vec the vector to edit x from
 * @param x the x value
 * @return the new vector data
*/
Vector3SetX :: proc(vec: Vector3, x: i64) -> Vector3 {
    return Vector3{x, vec[1], vec[2]}
}

/*
 * Vector3SetY sets the y value of a 3D int vector
 *
 *
 * @param vec the vector to edit y from
 * @param y the y value
 * @return the new vector data
*/
Vector3SetY :: proc(vec: Vector3, y: i64) -> Vector3 {
    return Vector3{vec[0], y, vec[2]}
}

/*
 * Vector3SetZ sets the z value of a 3D int vector
 *
 *
 * @param vec the vector to edit z from
 * @param z the z value
 * @return the new vector data
*/
Vector3SetZ :: proc(vec: Vector3, z: i64) -> Vector3 {
    return Vector3{vec[0], vec[1], z}
}

/*
 * Vector3fSetX sets the x value of a 3D float vector
 *
 *
 * @param vec the vector to edit x from
 * @param x the x value
 * @return the new vector data
*/
Vector3fSetX :: proc(vec: Vector3f, x: f64) -> Vector3f {
    return Vector3f{x, vec[1], vec[2]}
}

/*
 * Vector3fSetY sets the y value of a 3D float vector
 *
 *
 * @param vec the vector to edit y from
 * @param y the y value
 * @return the new vector data
*/
Vector3fSetY :: proc(vec: Vector3f, y: f64) -> Vector3f {
    return Vector3f{vec[0], y, vec[2]}
}

/*
 * Vector3fSetZ sets the z value of a 3D float vector
 *
 *
 * @param vec the vector to edit z from
 * @param z the z value
 * @return the new vector data
*/
Vector3fSetZ :: proc(vec: Vector3f, z: f64) -> Vector3f {
    return Vector3f{vec[0], vec[1], z}
}

/*
 * VectorAdd_Vector3 adds two int 3D vectors together
 *
 *
 * @param a a vector to add
 * @param b a vector to add
 * @return the new vector data
*/
VectorAdd_Vector3 :: proc(a, b: Vector3) -> Vector3 {
    return Vector3{
        a[0] + b[0],
        a[1] + b[1],
        a[2] + b[2],
    }
}

/*
 * VectorAdd_Vector3f adds two float 3D vectors together
 *
 *
 * @param a a vector to add
 * @param b a vector to add
 * @return the new vector data
*/
VectorAdd_Vector3f :: proc(a, b: Vector3f) -> Vector3f {
    return Vector3f{
        a[0] + b[0],
        a[1] + b[1],
        a[2] + b[2],
    }
}

/*
 * VectorSub_Vector3 subtracts two int 3D vectors together
 *
 *
 * @param a a vector to subtract
 * @param b a vector to subtract
 * @return the new vector data
*/
VectorSub_Vector3 :: proc(a, b: Vector3) -> Vector3 {
    return Vector3{
        a[0] - b[0],
        a[1] - b[1],
        a[2] - b[2],
    }
}

/*
 * VectorSub_Vector3f subtracts two float 3D vectors together
 *
 *
 * @param a a vector to subtract
 * @param b a vector to subtract
 * @return the new vector data
*/
VectorSub_Vector3f :: proc(a, b: Vector3f) -> Vector3f {
    return Vector3f{
        a[0] - b[0],
        a[1] - b[1],
        a[2] - b[2],
    }
}

/*
 * VectorMul_Vector3 multiplys two int 3D vectors together
 *
 *
 * @param a a vector to multiply
 * @param b a vector to multiply
 * @return the new vector data
*/
VectorMul_Vector3 :: proc(a, b: Vector3) -> Vector3 {
    return Vector3{
        a[0] * b[0],
        a[1] * b[1],
        a[2] * b[2],
    }
}

/*
 * VectorMul_Vector3f multiplys two float 3D vectors together
 *
 *
 * @param a a vector to multiply
 * @param b a vector to multiply
 * @return the new vector data
*/
VectorMul_Vector3f :: proc(a, b: Vector3f) -> Vector3f {
    return Vector3f{
        a[0] * b[0],
        a[1] * b[1],
        a[2] * b[2],
    }
}

/*
 * VectorDiv_Vector3 divides two int 3D vectors together
 *
 *
 * @param a a vector to divide
 * @param b a vector to divide
 * @return the new vector data
*/
VectorDiv_Vector3 :: proc(a, b: Vector3) -> Vector3 {
    return Vector3{
        a[0] / b[0],
        a[1] / b[1],
        a[2] / b[2],
    }
}

/*
 * VectorDiv_Vector3f divides two float 3D vectors together
 *
 *
 * @param a a vector to divide
 * @param b a vector to divide
 * @return the new vector data
*/
VectorDiv_Vector3f :: proc(a, b: Vector3f) -> Vector3f {
    return Vector3f{
        a[0] / b[0],
        a[1] / b[1],
        a[2] / b[2],
    }
}

/*
 * Vector4GetX returns the x value of a 4D int vector
 *
 *
 * @param vec The vector to read x from
 * @return the x value
*/
Vector4GetX :: proc (vec: Vector4) -> i64 {
    result: i64 = simd.extract(vec, 0)
    return result
}

/*
 * Vector4GetY returns the y value of a 4D int vector
 *
 *
 * @param vec The vector to read y from
 * @return the y value
*/
Vector4GetY :: proc (vec: Vector4) -> i64 {
    result: i64 = simd.extract(vec, 1)
    return result
}

/*
 * Vector4GetZ returns the x value of a 4D int vector
 *
 *
 * @param vec The vector to read z from
 * @return the z value
*/
Vector4GetZ :: proc (vec: Vector4) -> i64 {
    result: i64 = simd.extract(vec, 2)
    return result
}

/*
 * Vector4GetW returns the w value of a 4D int vector
 *
 *
 * @param vec The vector to read w from
 * @return the w value
*/
Vector4GetW :: proc (vec: Vector4) -> i64 {
    result: i64 = simd.extract(vec, 3)
    return result
}

/*
 * Vector4fGetX returns the x value of a 4D float vector
 *
 *
 * @param vec The vector to read x from
 * @return the x value
*/
Vector4fGetX :: proc (vec: Vector4f) -> f64 {
    result: f64 = simd.extract(vec, 0)
    return result
}

/*
 * Vector4fGetY returns the y value of a 4D float vector
 *
 *
 * @param vec The vector to read y from
 * @return the y value
*/
Vector4fGetY :: proc (vec: Vector4f) -> f64 {
    result: f64 = simd.extract(vec, 1)
    return result
}

/*
 * Vector4fGetZ returns the z value of a 4D float vector
 *
 *
 * @param vec The vector to read z from
 * @return the z value
*/
Vector4fGetZ :: proc (vec: Vector4f) -> f64 {
    result: f64 = simd.extract(vec, 2)
    return result
}

/*
 * Vector4fGetW returns the w value of a 4D float vector
 *
 *
 * @param vec The vector to read w from
 * @return the w value
*/
Vector4fGetW :: proc (vec: Vector4f) -> f64 {
    result: f64 = simd.extract(vec, 3)
    return result
}

/*
 * Vector4SetX sets the x value of a 4D int vector
 *
 *
 * @param vec the vector to edit x from
 * @param x the x value
 * @return the new vector data
*/
Vector4SetX :: proc(vec: Vector4, x: i64) -> Vector4 {
    return simd.replace(vec, 0, x)
}

/*
 * Vector4SetY sets the y value of a 4D int vector
 *
 *
 * @param vec the vector to edit x from
 * @param y the y value
 * @return the new vector data
*/
Vector4SetY :: proc(vec: Vector4, y: i64) -> Vector4 {
    return simd.replace(vec, 1, y)
}

/*
 * Vector4SetZ sets the z value of a 4D int vector
 *
 *
 * @param vec the vector to edit z from
 * @param z the z value
 * @return the new vector data
*/
Vector4SetZ :: proc(vec: Vector4, z: i64) -> Vector4 {
    return simd.replace(vec, 2, z)
}

/*
 * Vector4SetW sets the w value of a 4D int vector
 *
 *
 * @param vec the vector to edit w from
 * @param w the w value
 * @return the new vector data
*/
Vector4SetW :: proc(vec: Vector4, w: i64) -> Vector4 {
    return simd.replace(vec, 3, w)
}

/*
 * Vector4fSetX sets the x value of a 4D float vector
 *
 *
 * @param vec the vector to edit x from
 * @param x the x value
 * @return the new vector data
*/
Vector4fSetX :: proc(vec: Vector4f, x: f64) -> Vector4f {
    return simd.replace(vec, 0, x)
}

/*
 * Vector4fSetY sets the y value of a 4D float vector
 *
 *
 * @param vec the vector to edit y from
 * @param y the y value
 * @return the new vector data
*/
Vector4fSetY :: proc(vec: Vector4f, y: f64) -> Vector4f {
    return simd.replace(vec, 1, y)
}

/*
 * Vector4fSetZ sets the z value of a 4D float vector
 *
 *
 * @param vec the vector to edit z from
 * @param z the z value
 * @return the new vector data
*/
Vector4fSetZ :: proc(vec: Vector4f, z: f64) -> Vector4f {
    return simd.replace(vec, 2, z)
}

/*
 * Vector4fSetW sets the w value of a 4D float vector
 *
 *
 * @param vec the vector to edit w from
 * @param w the w value
 * @return the new vector data
*/
Vector4fSetW :: proc(vec: Vector4f, w: f64) -> Vector4f {
    return simd.replace(vec, 3, w)
}

/*
 * VectorAdd_Vector4 adds two int 4D vectors together
 *
 *
 * @param a a vector to add
 * @param b a vector to add
 * @return the new vector data
*/
VectorAdd_Vector4 :: proc(a, b: Vector4) -> Vector4 {
    return simd.add(a, b)
}

/*
 * VectorAdd_Vector4f adds two float 4D vectors together
 *
 *
 * @param a a vector to add
 * @param b a vector to add
 * @return the new vector data
*/
VectorAdd_Vector4f :: proc(a, b: Vector4f) -> Vector4f {
    return simd.add(a, b)
}

/*
 * VectorSub_Vector4 subtracts two int 4D vectors together
 *
 *
 * @param a a vector to subtract
 * @param b a vector to subtract
 * @return the new vector data
*/
VectorSub_Vector4 :: proc(a, b: Vector4) -> Vector4 {
    return simd.sub(a, b)
}

/*
 * VectorSub_Vector4f subtracts two float 4D vectors together
 *
 *
 * @param a a vector to subtract
 * @param b a vector to subtract
 * @return the new vector data
*/
VectorSub_Vector4f :: proc(a, b: Vector4f) -> Vector4f {
    return simd.sub(a, b)
}

/*
 * VectorMul_Vector4 multiplys two int 4D vectors together
 *
 *
 * @param a a vector to multiply
 * @param b a vector to multiply
 * @return the new vector data
*/
VectorMul_Vector4 :: proc(a, b: Vector4) -> Vector4 {
    return simd.mul(a, b)
}

/*
 * VectorMul_Vector4f multiplys two float 4D vectors together
 *
 *
 * @param a a vector to multiply
 * @param b a vector to multiply
 * @return the new vector data
*/
VectorMul_Vector4f :: proc(a, b: Vector4f) -> Vector4f {
    return simd.mul(a, b)
}

/*
 * VectorDiv_Vector4 divides two int 4D vectors together
 *
 *
 * @param a a vector to divide
 * @param b a vector to divide
 * @return the new vector data
*/
VectorDiv_Vector4 :: proc(a, b: Vector4) -> Vector4 {
    return cast(#simd[4]i64)simd.div(cast(#simd[4]f64)a, cast(#simd[4]f64)b)
}

/*
 * VectorDiv_Vector4f divides two float 4D vectors together
 *
 *
 * @param a a vector to divide
 * @param b a vector to divide
 * @return the new vector data
*/
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