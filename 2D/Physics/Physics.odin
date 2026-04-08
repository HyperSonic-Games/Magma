package Physics

import "core:math"
import "core:math/linalg"
import "core:thread"
import "core:sync"
import "core:time"

import "../../Types"

Vec2 :: Types.Vector2f

Object :: struct {
    pos: Vec2,
    width: f32,
    height: f32,
    rot: f32,

    is_static: bool,
}

ObjectID :: u64

World :: struct {
    objects: map[ObjectID]^Object,

    mutex: sync.Mutex,

    running: bool,
    solver_thread: ^thread.Thread,
}

CollisionInfo :: struct {
    other: ObjectID,
    mtv: Vec2,
}

perp :: proc(v: Vec2) -> Vec2 {
    return Vec2{-v.y, v.x}
}

@(private)
GetCorners :: proc(o: Object) -> [4]Vec2 {
    hw := o.width * 0.5
    hh := o.height * 0.5

    rad := -o.rot * math.PI / 180.0
    c := math.cos(rad)
    s := math.sin(rad)

    local := [4]Vec2{
        {-hw, -hh},
        { hw, -hh},
        { hw,  hh},
        {-hw,  hh},
    }

    center := Vec2{o.pos.x + hw, o.pos.y + hh}

    corners: [4]Vec2
    for i in 0..<4 {
        x := local[i].x
        y := local[i].y

        corners[i] = Vec2{
            center.x + x*c - y*s,
            center.y + x*s + y*c,
        }
    }

    return corners
}

@(private)
Project :: proc(points: [4]Vec2, axis: Vec2) -> (f32, f32) {
    min := linalg.dot(points[0], axis)
    max := min

    for i in 1..<4 {
        p := linalg.dot(points[i], axis)
        if p < min { min = p }
        if p > max { max = p }
    }

    return min, max
}

@(private)
OBBOverlap :: proc(a, b: Object) -> (bool, Vec2) {
    ac := GetCorners(a)
    bc := GetCorners(b)

    axes: [4]Vec2

    axes[0] = linalg.normalize(perp(ac[1] - ac[0]))
    axes[1] = linalg.normalize(perp(ac[3] - ac[0]))
    axes[2] = linalg.normalize(perp(bc[1] - bc[0]))
    axes[3] = linalg.normalize(perp(bc[3] - bc[0]))

    smallest_overlap := f32(1e30)
    smallest_axis := Vec2{}

    for axis in axes {
        minA, maxA := Project(ac, axis)
        minB, maxB := Project(bc, axis)

        overlap := math.min(maxA, maxB) - math.max(minA, minB)

        if overlap <= 0.001 {
            return false, Vec2{}
        }

        if overlap < smallest_overlap {
            smallest_overlap = overlap
            smallest_axis = axis
        }
    }

    a_center := Vec2{a.pos.x + a.width*0.5, a.pos.y + a.height*0.5}
    b_center := Vec2{b.pos.x + b.width*0.5, b.pos.y + b.height*0.5}

    dir := b_center - a_center

    if linalg.dot(dir, smallest_axis) < 0 {
        smallest_axis *= -1
    }

    return true, smallest_axis * smallest_overlap
}

@(private)
SolveCollisions :: proc(world: ^World) {
    // assumes lock held

    for id_a, a in world.objects {
        if a == nil || a.is_static {
            continue
        }

        for id_b, b in world.objects {
            if b == nil || id_a == id_b {
                continue
            }

            colliding, mtv := OBBOverlap(a^, b^)
            if !colliding {
                continue
            }

            if b.is_static {
                a.pos -= mtv
            } else {
                // split correction (reduces jitter)
                a.pos -= mtv * 0.5
                b.pos += mtv * 0.5
            }
        }
    }
}

SolverThreadProc :: proc(data: rawptr) {
    world := (^World)(data)

    for world.running {
        sync.mutex_lock(&world.mutex)

        SolveCollisions(world)

        sync.mutex_unlock(&world.mutex)

        time.sleep(1 * time.Millisecond)
    }
}

StartSolver :: proc(world: ^World) {
    world.running = true
    world.solver_thread = thread.create_and_start_with_data(world, SolverThreadProc)
}

StopSolver :: proc(world: ^World) {
    world.running = false
    thread.join(world.solver_thread)
}

MoveObject :: proc(world: ^World, id: ObjectID, amount: Vec2) {
    sync.mutex_lock(&world.mutex)
    defer sync.mutex_unlock(&world.mutex)

    obj, ok := world.objects[id]
    if !ok || obj == nil {
        return
    }

    if obj.is_static {
        return
    }

    obj.pos += amount
}

IsCollidingWith :: proc(world: ^World, id: ObjectID) -> (ObjectID, bool) {
    sync.mutex_lock(&world.mutex)
    defer sync.mutex_unlock(&world.mutex)

    a, ok := world.objects[id]
    if !ok || a == nil {
        return 0, false
    }

    for other_id, b in world.objects {
        if b == nil || other_id == id {
            continue
        }

        colliding, _ := OBBOverlap(a^, b^)
        if colliding {
            return other_id, true
        }
    }

    return 0, false
}

GetCollisions :: proc(world: ^World, id: ObjectID) -> []CollisionInfo {
    sync.mutex_lock(&world.mutex)
    defer sync.mutex_unlock(&world.mutex)

    a, ok := world.objects[id]
    if !ok || a == nil {
        return nil
    }

    results: [dynamic]CollisionInfo

    for other_id, b in world.objects {
        if b == nil || other_id == id {
            continue
        }

        colliding, mtv := OBBOverlap(a^, b^)
        if colliding {
            append(&results, CollisionInfo{
                other = other_id,
                mtv = mtv,
            })
        }
    }

    return results[:]
}