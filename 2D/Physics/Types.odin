package Physics

import "core:math"

Meters :: distinct f32
Seconds :: distinct f32
Kilograms :: distinct f32

MetersPerSecond :: distinct f32
MetersPerSecondSq :: distinct f32
Newtons :: distinct f32

Degrees :: distinct f32
DegreesPerSecond :: distinct f32
DegreesPerSecondSq :: distinct f32
Radians :: distinct f32
RadiansPerSecond :: distinct f32
RadiansPerSecondSq :: distinct f32
NewtonMeters :: distinct f32



InverseMass         :: distinct f32
InverseInertia      :: distinct f32   // still 1 / (kg·m^2)



EARTH_GRAVITY ::  [?]MetersPerSecond{0, 9.81}

DegToRad :: #force_inline proc(d: Degrees) -> Radians {
    return cast(Radians)math.to_radians(cast(f32)d)
}

RadToDeg :: #force_inline proc(r: Radians) -> Degrees {
    return cast(Degrees)math.to_degrees(cast(f32)r)
}