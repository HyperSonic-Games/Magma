package Physics

import "base:runtime"
import "vendor:box2d"
import "core:mem"
import "core:mem/tlsf"

@(private)
BackingAllocator: mem.Allocator

@(private)
TLSFInternalAllocator: tlsf.Allocator

@(private)
TLSFAllocator: mem.Allocator

@(private, init)
InitBox2DAllocator :: proc() {
    BackingAllocator = context.allocator
    err := tlsf.init_from_allocator(
        &TLSFInternalAllocator,
        BackingAllocator,
        TLSF_ALLOCATOR_MEM_POOL_SIZE,
        TLSF_ALLOCATOR_MEM_POOL_SIZE
    )

    if err != .None {
        panic("Could not create a TLSF allocator")
    }
    TLSFAllocator = tlsf.allocator(&TLSFInternalAllocator)
}

@(private, fini)
DestroyBox2DAllocator :: proc() {
    tlsf.destroy(&TLSFInternalAllocator)
}

@(private)
Box2DAllocate :: proc "c" (size: u32, alignment: i32) -> rawptr {
    context = runtime.default_context()
    context.allocator = TLSFAllocator
    ptr, err := mem.alloc(cast(int)size, cast(int)alignment)
    if err != nil {
        return nil
    }
    return ptr
}

@(private)
Box2DFree :: proc "c" (ptr: rawptr) {
    context = runtime.default_context()
    context.allocator = TLSFAllocator
    mem.free(ptr)
}


AABB :: box2d.AABB
BodyEvents :: box2d.BodyEvents
Body :: box2d.BodyId
BodyMoveEvent :: box2d.BodyMoveEvent
BodyType :: box2d.BodyType
Capsule :: box2d.Capsule
CastOutput :: box2d.CastOutput
Chain :: box2d.ChainId
ChainSegment :: box2d.ChainSegment
Circle :: box2d.Circle
CollisionPlane :: box2d.CollisionPlane
ContactBeginTouchEvent :: box2d.ContactBeginTouchEvent
ContactData :: box2d.ContactData
ContactEndTouchEvent :: box2d.ContactEndTouchEvent
ContactEvents :: box2d.ContactEvents
ContactHitEvent :: box2d.ContactHitEvent
CosSin :: box2d.CosSin
Counters :: box2d.Counters
@(private)
DebugDraw :: box2d.DebugDraw
DistanceInput :: box2d.DistanceInput
DistanceOutput :: box2d.DistanceOutput
Filter :: box2d.Filter
HexColor :: box2d.HexColor
Hull :: box2d.Hull
Joint :: box2d.JointId
JointType :: box2d.JointType
Manifold :: box2d.Manifold
ManifoldPoint :: box2d.ManifoldPoint
MassData :: box2d.MassData
Plane :: box2d.Plane
PlaneResult :: box2d.PlaneResult
Polygon :: box2d.Polygon
@(private)
Profile :: box2d.Profile
QueryFilter :: box2d.QueryFilter
RaycastInput :: box2d.RayCastInput
RayResult :: box2d.RayResult
Segment :: box2d.Segment
SegmentDistanceResult :: box2d.SegmentDistanceResult
SensorBeginTouchEvent :: box2d.SensorBeginTouchEvent
SensorEndTouchEvent :: box2d.SensorEndTouchEvent
SensorEvents :: box2d.SensorEvents
ShapeCastInput :: box2d.ShapeCastInput
ShapeCastPairInput :: box2d.ShapeCastPairInput
Shape :: box2d.ShapeId
ShapeType :: box2d.ShapeType
SurfaceMaterial :: box2d.SurfaceMaterial
@(private)
TreeStats :: box2d.TreeStats
World :: box2d.WorldId
