package Physics

import "base:runtime"
import "core:math"
import "core:math/linalg"
import "core:mem"
import "core:mem/tlsf"
import "../../Util"
import "../../Types"


// --------------------------------------------------
// Handles & shape types
// --------------------------------------------------

BodyHandle :: distinct i32

ShapeKind :: enum {
    Circle,
    Rect,
    Capsule,
    Polygon,
}


// --------------------------------------------------
// Body definition (all-in-one, unused = zero / nil)
// --------------------------------------------------

@private
Body :: struct {
    // --- Transform ---
    pos: Types.Vector2f,
    rot: f32,

    // --- Motion ---
    vel: Types.Vector2f,
    ang_vel: f32,

    // --- Forces ---
    force: Types.Vector2f,
    torque: f32,

    // --- Mass ---
    mass: f32,
    inv_mass: f32,
    inertia: f32,
    inv_inertia: f32,

    // --- Material ---
    friction_static: f32,
    friction_kinetic: f32,
    restitution: f32,

    // --- Shape type ---
    shape: ShapeKind,

    // ---------- Geometry (unused = zero / nil) ----------

    // Circle
    circle_radius: f32,

    // Rectangle
    rect_half_extents: Types.Vector2f,

    // Capsule
    capsule_half_height: f32,
    capsule_radius: f32,

    // Polygon
    poly_count: i32,
    poly_verts: []Types.Vector2f, // nil unless polygon

    // --- Flags ---
    is_static: bool,
    is_trigger: bool,
}


// --------------------------------------------------
// Storage
// --------------------------------------------------

@private
BodyHandlesToPointers: map[BodyHandle]^Body

@private
CurrentGeneration: BodyHandle = -2147483648


// --------------------------------------------------
// Handle management
// --------------------------------------------------

@(private)
RequestNewHandle :: proc() -> BodyHandle #no_bounds_check {
    if CurrentGeneration == 2147483647 {
        panic("RequestNewHandle: handle generation overflow")
    }
    CurrentGeneration += 1
    return CurrentGeneration
}


BodiesAllocatorTLSF: tlsf.Allocator
BodiesAllocator: mem.Allocator

@(init, private)
InitBodyAllocator :: proc() {
    err := tlsf.init_from_allocator(
        &BodiesAllocatorTLSF,
        runtime.heap_allocator(),
        size_of(Body) * 100,
        size_of(Body) * 10,
    )
    if err != .None {
        Util.log(
            .ERROR,
            "MAGMA",
            "PHYSICS_ENGINE_BODY_MANAGER_INIT_ALLOCATOR",
            "Could not create allocator\nFailed with error: %s",
            err,
        )
    }

    BodyHandlesToPointers = make(map[BodyHandle]^Body)
    BodiesAllocator = tlsf.allocator(&BodiesAllocatorTLSF)
}

@(fini, private)
ShutdownBodyAllocator :: proc() {
    tlsf.destroy(&BodiesAllocatorTLSF)
}


AllocateBody :: proc() -> BodyHandle {
    body := new(Body, BodiesAllocator)

    handle := RequestNewHandle()
    BodyHandlesToPointers[handle] = body

    return handle
}

FreeBody :: proc(handle: BodyHandle) {
    body, ok := BodyHandlesToPointers[handle]
    if !ok {
        return
    }

    // free polygon memory if used
    if body.shape == .Polygon && body.poly_verts != nil {
        delete(body.poly_verts)
        body.poly_verts = nil
        body.poly_count = 0
    }

    free(body, BodiesAllocator)
    delete_key(&BodyHandlesToPointers, handle)
}


SetupBody :: proc(
    handle: BodyHandle,
    pos: Types.Vector2f,
    rot: f32,
    density: f32,
    friction_static: f32,
    friction_kinetic: f32,
    restitution: f32,
    is_static: bool,
    is_trigger: bool,
    shape: ShapeKind,
    circle_radius: f32,
    rect_half_extents: Types.Vector2f,
    capsule_half_height: f32,
    capsule_radius: f32,
    poly_count: i32,
    poly_verts: []Types.Vector2f,
) {
    body, ok := BodyHandlesToPointers[handle]
    if !ok {
        return
    }

    // --- Reset motion and forces ---
    body.vel = {}
    body.ang_vel = 0
    body.force = {}
    body.torque = 0

    // --- Material ---
    body.friction_static = friction_static
    body.friction_kinetic = friction_kinetic
    body.restitution = restitution

    // --- Flags ---
    body.is_static = is_static
    body.is_trigger = is_trigger

    // --- Shape ---
    body.shape = shape
    body.circle_radius = circle_radius
    body.rect_half_extents = rect_half_extents
    body.capsule_half_height = capsule_half_height
    body.capsule_radius = capsule_radius
    body.poly_count = poly_count
    body.poly_verts = poly_verts

    if is_static {
        body.mass = 0
        body.inv_mass = 0
        body.inertia = 0
        body.inv_inertia = 0
        body.pos = pos
        body.rot = rot
        return
    }

    // --- Mass & inertia per shape ---
    switch shape {
    case .Circle:
        body.mass = math.PI * circle_radius*circle_radius * density
        body.inertia = 0.5 * body.mass * circle_radius*circle_radius

    case .Rect:
        w := rect_half_extents.x*2
        h := rect_half_extents.y*2
        body.mass = w*h*density
        body.inertia = body.mass * (w*w + h*h)/12

    case .Capsule:
        rect_mass := capsule_half_height*2 * (2*capsule_radius) * density
        circle_mass := math.PI * capsule_radius*capsule_radius * density
        body.mass = rect_mass + circle_mass
        body.inertia = rect_mass*((capsule_half_height*2)*(capsule_half_height*2)+(2*capsule_radius)*(2*capsule_radius))/12+circle_mass*(0.5*capsule_radius*capsule_radius+(capsule_half_height)*(capsule_half_height))

    case .Polygon:
        if poly_verts != nil && poly_count > 0 {
            centroid := Types.Vector2f{}
            area: f32 = 0
            for i in 0..<poly_count {
                a := poly_verts[i]
                b := poly_verts[(i+1) % poly_count]
                cross := a.x*b.y - b.x*a.y
                area += cross
                centroid += (a + b) * cross
            }
            area *= 0.5
            centroid /= (6*area)

            for i in 0..<poly_count {
                poly_verts[i].x -= centroid.x
                poly_verts[i].y -= centroid.y
            }

            body.mass = math.abs(area) * density

            inertia: f32 = 0
            for i in 0..<poly_count {
                a := poly_verts[i]
                b := poly_verts[(i+1) % poly_count]
                cross := math.abs(a.x*b.y - b.x*a.y)
                inertia += cross * (linalg.dot(a,a) + linalg.dot(a,b) + linalg.dot(b,b))
            }
            body.inertia = body.mass * inertia / 6
        } else {
            body.mass = 0
            body.inertia = 0
        }
    }

    if body.mass > 0 {
        body.inv_mass = 1.0 / body.mass
    } else {
        body.inv_mass = 0
    }
    if body.inertia > 0 {
        body.inv_inertia = 1.0 / body.inertia
    } else {
        body.inv_inertia = 0
    }

    body.pos = pos
    body.rot = rot
}
