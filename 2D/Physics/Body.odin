package Physics


import "vendor:box2d"

import "../../Types"
import "../../Util"

Body :: struct {
    _body: box2d.BodyId,
    is_circle: bool
}

BodyType :: enum {
    STATIC,
    CHARACTER,
    DYNAMIC
}

/*
creates a new body for the physics engine
@param is_circle should this body be treated like a circle (set to true for non square/sharp objects)
@param angular_damping angular damping is used to reduce the angular velocity. The damping parameter can be larger than 1.0f but the damping effect becomes sensitive to the time step when the damping parameter is large. Angular damping can be use slow down rotating bodies
@param inital_angular_velocity the initial angular velocity of the body in radians per second
@param can_sleep set this flag to false if this body should never fall asleep
@param no_rot set to true to prevent the body from rotating via physics
@param grav_scale scale the gravity applied to this body
@param is_bullet treat this body as high speed object that performs continuous collision detection against dynamic and kinematic bodies, but not other bullet bodies
@param is_disabled used to disable a body. a disabled body does not move or collide
@param linear_damping used to reduce the linear velocity. The damping parameter can be larger than 1 but the damping effect becomes sensitive to the time step when the damping parameter is large
@param initial_linear_velocity the initial linear velocity of the body's origin. Usually in meters per second
@param debug_name optional body name for debugging. Up to 32 characters allowed (ignored in non DEBUG builds)
@param posistion the initial world position of the body (make sure to call ScreenVectorToPhysics if passing in values from the renderer)
@param rotation the inital rotation of the body in radians (make sure to call ScreenToPhysicsRotation if passing in values from the renderer)
@return a pointer to the newly created body
*/
CreateBody :: proc(
    world: World,
    is_circle: bool = false,
    angular_damping: f32 = 0,
    initial_angular_velocity: f32 = 0,
    can_sleep: bool = true,
    no_rot: bool = false,
    grav_scale: f32 = 1,
    is_bullet: bool = false,
    is_dissabled: bool = false,
    linear_damping: f32 = 0,
    initial_linear_velocity: Types.Vector2f = {0, 0},
    debug_name: cstring = nil,
    posistion: Types.Vector2f,
    rotation: f32,
    type: BodyType
) -> ^Body {

    body_def := box2d.DefaultBodyDef()

    body_def.allowFastRotation = is_circle ? true : false
    body_def.angularDamping = angular_damping
    body_def.angularVelocity = initial_angular_velocity
    body_def.enableSleep = can_sleep
    body_def.fixedRotation = no_rot
    body_def.gravityScale = grav_scale
    body_def.isAwake = true
    body_def.isBullet = is_bullet
    body_def.isEnabled = !is_dissabled
    body_def.linearDamping = linear_damping
    body_def.linearVelocity = initial_linear_velocity
    when ODIN_DEBUG {
        body_def.name = debug_name
    }
    body_def.position = posistion
    body_def.rotation = box2d.MakeRot(rotation)

    switch type {
        case .STATIC:
            body_def.type = box2d.BodyType.staticBody
        case .CHARACTER:
            body_def.type = box2d.BodyType.kinematicBody
        case .DYNAMIC:
            body_def.type = box2d.BodyType.dynamicBody
        
    }

    body, err := new(Body)
    if err != .None {
        Util.Log(.ERROR, "MAGMA", "2D_PHYSICS_CREATE_BODY", "Could not allocate a new body: %s", err)
    }

    body.is_circle = is_circle
    body._body = box2d.CreateBody(transmute(box2d.WorldId)world, body_def)
    
    if !box2d.IsValid(body._body) {
        Util.Log(.ERROR, "MAGMA", "2D_PHYSICS_CREATE_BODY", "Handle returned from box2d was invalid")
    }
    return body
}

