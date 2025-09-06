package Physics

import "../../Types"
import "../../Util"
import b2d "vendor:box2d"

// 60 fps physics timestep
PHYSICS_TIMESTEP :: #config(magma_physics_timestep, 0.01666666666)
// Number of substeps per physics step, usually 4
PHYSICS_SUB_TIMESTEP :: #config(magma_physics_sub_timestep, 4)

World :: distinct b2d.WorldId  // Physics world handle
Obj :: distinct b2d.BodyId      // Physics body handle
ObjPhysicsHandle :: distinct b2d.ShapeId  // Physics shape handle



/*
 * InitPhysicsEngine initializes a Box2D world with gravity and settings.
 * @param grav_vector gravity vector (x, y)
 * @param can_sleep whether bodies can go to sleep for performance
 * @param collision_is_continuous enables continuous collision detection
 * @return World physics world handle
*/
InitPhysicsEngine :: proc(grav_vector: Types.Vector2f, can_sleep := true, collision_is_continuous := true) -> World {
    world: World

    world_def := b2d.DefaultWorldDef()
    world_def.enableSleep = can_sleep
    world_def.gravity[0] = cast(f32) Types.Vector2fGetX(grav_vector)
    world_def.gravity[1] = cast(f32) Types.Vector2fGetY(grav_vector)
    world_def.enableContinuous = collision_is_continuous

    world = cast(World)b2d.CreateWorld(world_def)
    return world
}

/*
 * DestroyPhysicsEngine destroys a physics world and frees resources.
 * @param world the world to destroy
*/
DestroyPhysicsEngine :: proc (world: World) {
    b2d.DestroyWorld(cast(b2d.WorldId)world)
}

/*
 * CreateStaticBody creates a static (immovable) body in the physics world.
 * @param world the physics world
 * @param pos body position
 * @param angle body angle in radians
 * @param can_sleep whether the body can sleep
 * @param no_physics_rot prevents physics-based rotation if true
 * @return Obj handle to the body
*/
CreateStaticBody :: proc (world: World,
    pos: Types.Vector2f,
    angle: Radians = 0,
    can_sleep := true,
    no_physics_rot := true
)-> Obj {
    body_def := b2d.DefaultBodyDef()
    body_def.allowFastRotation = false
    body_def.enableSleep = can_sleep
    body_def.fixedRotation = no_physics_rot
    body_def.position[0] = cast(f32)Types.Vector2fGetX(pos)
    body_def.position[1] = cast(f32)Types.Vector2fGetY(pos)
    body_def.rotation = b2d.MakeRot(angle)
    body_def.type = .staticBody

    return cast(Obj)b2d.CreateBody(cast(b2d.WorldId)world, body_def)
}

/*
 * CreateDynamicBody creates a dynamic (movable) body in the physics world.
 * @param world the physics world
 * @param pos body position
 * @param angle body angle in radians
 * @param can_sleep whether the body can sleep
 * @param no_physics_rot prevents physics-based rotation if true
 * @return Obj handle to the body
*/
CreateDynamicBody :: proc (world: World,
    pos: Types.Vector2f,
    angle: Radians = 0,
    can_sleep := true,
    no_physics_rot := true
)-> Obj {
    body_def := b2d.DefaultBodyDef()
    body_def.allowFastRotation = false
    body_def.enableSleep = can_sleep
    body_def.fixedRotation = no_physics_rot
    body_def.position[0] = cast(f32)Types.Vector2fGetX(pos)
    body_def.position[1] = cast(f32)Types.Vector2fGetY(pos)
    body_def.rotation = b2d.MakeRot(angle)
    body_def.type = .dynamicBody

    return cast(Obj)b2d.CreateBody(cast(b2d.WorldId)world, body_def)
}

/*
 * AddPhysicsPolygonToBody attaches a polygon shape with physics properties to a body.
 * @param obj the body to attach to
 * @param vertices array of polygon vertices
 * @param radius rounding radius for edges
 * @param density material density
 * @param mat_registry_name key to look up material in registry
 * @return ObjPhysicsHandle handle to the shape
*/
AddPhysicsPolygonToBody :: proc (
    obj: Obj, 
    vertices: [][2]f32, 
    radius: f32,
    density: f32,
    mat_registry_name: string
) -> ObjPhysicsHandle {
    shape_hull := b2d.ComputeHull(vertices)
    shape_polygon := b2d.MakePolygon(shape_hull, radius)
    shape_def := b2d.DefaultShapeDef()
    shape_def.density = density
    shape_def.material = MaterialRegistry[mat_registry_name]
    return cast(ObjPhysicsHandle)b2d.CreatePolygonShape(cast(b2d.BodyId)obj, shape_def, shape_polygon)
}

/*
 * Step advances the physics simulation forward in time.
 * @param world the physics world
 * @param delta_time delta time multiplier
*/
Step :: proc(world: World, delta_time: f32) {
    time_step: f32 = PHYSICS_TIMESTEP * delta_time
    b2d.World_Step(cast(b2d.WorldId)world, time_step, PHYSICS_SUB_TIMESTEP)
}

/*
 * GetObjectPos returns the current position of a physics object.
 * @param obj the object to query
 * @return Vector2f current position
*/
GetObjectPos :: proc(obj: Obj) -> Types.Vector2f {
    obj_transform := b2d.Body_GetTransform(cast(b2d.BodyId)obj)
    return {cast(f64)obj_transform.p[0], cast(f64)obj_transform.p[1]}
}

/*
 * GetObjectRot returns the current rotation (angle in radians) of a physics object.
 * @param obj the object to query
 * @return Radians current rotation
*/
GetObjectRot :: proc(obj: Obj) -> Radians {
    obj_transform := b2d.Body_GetTransform(cast(b2d.BodyId)obj)
    return b2d.Rot_GetAngle(obj_transform.q)
}
