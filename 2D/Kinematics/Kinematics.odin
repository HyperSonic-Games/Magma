package Kinematics

import "core:math"
import "core:math/linalg"
import "core:thread"
import "core:sync"
import "core:time"

import "../../Types"


Object :: struct {
    pos: Types.Vector2f,
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
    mtv: Types.Vector2f,
}

@(private)
perp :: proc(v: Types.Vector2f) -> Types.Vector2f {
    return Types.Vector2f{-v.y, v.x}
}

@(private)
GetCorners :: proc(o: Object) -> [4]Types.Vector2f {
    hw := o.width * 0.5
    hh := o.height * 0.5

    rad := -o.rot * math.PI / 180.0
    c := math.cos(rad)
    s := math.sin(rad)

    local := [4]Types.Vector2f{
        {-hw, -hh},
        { hw, -hh},
        { hw,  hh},
        {-hw,  hh},
    }

    center := Types.Vector2f{o.pos.x + hw, o.pos.y + hh}

    corners: [4]Types.Vector2f
    for i in 0..<4 {
        x := local[i].x
        y := local[i].y

        corners[i] = Types.Vector2f{
            center.x + x*c - y*s,
            center.y + x*s + y*c,
        }
    }

    return corners
}

@(private)
Project :: proc(points: [4]Types.Vector2f, axis: Types.Vector2f) -> (f32, f32) {
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
OBBOverlap :: proc(a, b: Object) -> (bool, Types.Vector2f) {
    ac := GetCorners(a)
    bc := GetCorners(b)

    axes: [4]Types.Vector2f

    axes[0] = linalg.normalize(perp(ac[1] - ac[0]))
    axes[1] = linalg.normalize(perp(ac[3] - ac[0]))
    axes[2] = linalg.normalize(perp(bc[1] - bc[0]))
    axes[3] = linalg.normalize(perp(bc[3] - bc[0]))

    smallest_overlap := f32(1e30)
    smallest_axis := Types.Vector2f{}

    for axis in axes {
        minA, maxA := Project(ac, axis)
        minB, maxB := Project(bc, axis)

        overlap := math.min(maxA, maxB) - math.max(minA, minB)

        if overlap <= 0.001 {
            return false, Types.Vector2f{}
        }

        if overlap < smallest_overlap {
            smallest_overlap = overlap
            smallest_axis = axis
        }
    }

    a_center := Types.Vector2f{a.pos.x + a.width*0.5, a.pos.y + a.height*0.5}
    b_center := Types.Vector2f{b.pos.x + b.width*0.5, b.pos.y + b.height*0.5}

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

@(private)
SolverThreadProc :: proc(data: rawptr) {
    world := (^World)(data)

    for world.running {
        sync.mutex_lock(&world.mutex)

        SolveCollisions(world)

        sync.mutex_unlock(&world.mutex)

        time.sleep(1 * time.Millisecond)
    }
}

/*
starts the kinematics solver in a new thread
@param world a pointer to the world to create a solver for
*/
StartSolver :: proc(world: ^World) {
    world.running = true
    world.solver_thread = thread.create_and_start_with_data(world, SolverThreadProc)
}

/*
stops the kinematics solver associated with the world
@param world a pointer to the world that owns the solver we want to stop
*/
StopSolver :: proc(world: ^World) {
    world.running = false
    thread.join(world.solver_thread)
}

/*
attempt to move an object in a world by a certain amount
note that this acts more like a maximum posible as the kinematics will check for collisions
and could cause the object to not move at all
@param world a pointer to the world that owns the object we want to move
@param id the id of the object we want to move
@param amount the amount in pixels we want to move
*/
MoveObject :: proc(world: ^World, id: ObjectID, amount: Types.Vector2f) {
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
/*
checks if an object is coliding with another object and gives you the id of the other object
@param world a pointer to the world that owns the object to check and the returned id
@param id the id of the object we want to check
@return the id of the object that we collided with and true if we collided with anything or false if not
*/
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
/*
similar to IsCollidingWith but returns multiple objects that the object is colliding with
and in complex scenes is prefered over it
@param world a pointer to the world that owns the objects we want to check
@param id the id of the object we want to check collisions against
@return a list of collisions and their info
*/
GetCollisions :: proc(world: ^World, id: ObjectID) -> []CollisionInfo {
    sync.mutex_lock(&world.mutex)
    defer sync.mutex_unlock(&world.mutex)

    a, ok := world.objects[id]
    if !ok || a == nil {
        return nil
    }

    results: [dynamic]CollisionInfo
    defer delete(results)

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