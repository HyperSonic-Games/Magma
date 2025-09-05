package Physics

import "../../Types"
import "../../Util"
import b2d "vendor:box2d"


JointHandle :: b2d.JointId


CreateDistanceJoint :: proc(
    world: World,
    obj_a: Obj,
    obj_b: Obj,
    anchor_a: Types.Vector2f,
    anchor_b: Types.Vector2f,
    rest_length: Meters,
    min_length: Meters,
    max_length: Meters,
    handle_collision: bool = true
) -> JointHandle {
    jointDef := new(b2d.DistanceJointDef)
    defer free(jointDef)
    jointDef.bodyIdA = cast(b2d.BodyId)obj_a
    jointDef.bodyIdB = cast(b2d.BodyId)obj_b
    jointDef.collideConnected = handle_collision
    jointDef.length = rest_length
    jointDef.maxLength = max_length
    jointDef.minLength = min_length
    jointDef.enableLimit = true
    jointDef.enableMotor = false
    jointDef.enableSpring = false
    jointDef.localAnchorA = {cast(f32)Types.Vector2fGetX(anchor_a), cast(f32)Types.Vector2fGetY(anchor_a)}
    jointDef.localAnchorB = {cast(f32)Types.Vector2fGetX(anchor_b), cast(f32)Types.Vector2fGetY(anchor_b)}
    return b2d.CreateDistanceJoint(cast(b2d.WorldId)world, jointDef^)
}

CreateSpringJoint :: proc(
    world: World,
    obj_a: Obj,
    obj_b: Obj,
    anchor_a: Types.Vector2f,
    anchor_b: Types.Vector2f,
    rest_length: Meters,
    min_length: Meters,
    max_length: Meters,
    hertz: Hertz,
    damping: f32,
    handle_collision: bool = true
) -> JointHandle {
    jointDef := new(b2d.DistanceJointDef)
    defer free(jointDef)
    jointDef.bodyIdA = cast(b2d.BodyId)obj_a
    jointDef.bodyIdB = cast(b2d.BodyId)obj_b
    jointDef.collideConnected = handle_collision
    jointDef.enableLimit = true
    jointDef.length = rest_length
    jointDef.maxLength = max_length
    jointDef.minLength = min_length
    jointDef.enableMotor = false
    jointDef.enableSpring = true
    jointDef.hertz = hertz
    jointDef.dampingRatio = damping
    jointDef.localAnchorA = {cast(f32)Types.Vector2fGetX(anchor_a), cast(f32)Types.Vector2fGetY(anchor_a)}
    jointDef.localAnchorB = {cast(f32)Types.Vector2fGetX(anchor_b), cast(f32)Types.Vector2fGetY(anchor_b)}
    return b2d.CreateDistanceJoint(cast(b2d.WorldId)world, jointDef^)
}

CreateLinearActuatorJoint :: proc(
    world: World,
    obj_a: Obj,
    obj_b: Obj,
    anchor_a: Types.Vector2f,
    anchor_b: Types.Vector2f,
    rest_length: Meters,
    min_length: Meters,
    max_length: Meters,
    max_force: Newtons,
    speed: MetersPerSecond,
    handle_collision: bool = true
) -> JointHandle {
    jointDef := new(b2d.DistanceJointDef)
    defer free(jointDef)
    jointDef.bodyIdA = cast(b2d.BodyId)obj_a
    jointDef.bodyIdB = cast(b2d.BodyId)obj_b
    jointDef.collideConnected = handle_collision
    jointDef.length = rest_length
    jointDef.enableMotor = true
    jointDef.enableLimit = true
    jointDef.maxLength = max_length
    jointDef.minLength = min_length
    jointDef.maxMotorForce = max_force
    jointDef.motorSpeed = speed
    jointDef.enableSpring = false
    jointDef.localAnchorA = {cast(f32)Types.Vector2fGetX(anchor_a), cast(f32)Types.Vector2fGetY(anchor_a)}
    jointDef.localAnchorB = {cast(f32)Types.Vector2fGetX(anchor_b), cast(f32)Types.Vector2fGetY(anchor_b)}
    return b2d.CreateDistanceJoint(cast(b2d.WorldId)world, jointDef^)
}

CreateMotorJoint :: proc(
    world: World,
    obj_a: Obj,
    obj_b: Obj,
    anchor_a: Types.Vector2f,
    anchor_b: Types.Vector2f,
    motor_speed: RadiansPerSecond,
    max_torque: NewtonMeters,
    enable_motor: bool = true,
    handle_collision: bool = true,
) -> JointHandle {
    jointDef := new(b2d.RevoluteJointDef)
    defer free(jointDef)

    // Bodies to connect
    jointDef.bodyIdA = cast(b2d.BodyId)obj_a
    jointDef.bodyIdB = cast(b2d.BodyId)obj_b

    // Separate anchors for each body
    jointDef.localAnchorA = {cast(f32)Types.Vector2fGetX(anchor_a), cast(f32)Types.Vector2fGetY(anchor_a)}
    jointDef.localAnchorB = {cast(f32)Types.Vector2fGetX(anchor_b), cast(f32)Types.Vector2fGetY(anchor_b)}

    // Motor settings
    jointDef.enableMotor = enable_motor
    jointDef.motorSpeed = motor_speed
    jointDef.maxMotorTorque = max_torque

    // Let objects collide or not
    jointDef.collideConnected = handle_collision

    return b2d.CreateRevoluteJoint(cast(b2d.WorldId)world, jointDef^)
}

DestroyJoint :: proc(joint: JointHandle) {
    b2d.DestroyJoint(joint)
}



DistanceJointGetRestLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetLength(joint)
}

DistanceJointGetMaxLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetMaxLength(joint)
}

DistanceJointGetMinLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetMinLength(joint)
}

DistanceJointGetCurrentLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetCurrentLength(joint)
}

DistanceJointSetRestLength :: proc(joint: JointHandle, length: Meters) {
    b2d.DistanceJoint_SetLength(joint, length)
}

DistanceJointSetMinLength :: proc(joint: JointHandle, min_length: Meters) {
    b2d.DistanceJoint_SetLengthRange(joint, min_length, DistanceJointGetMaxLength(joint))
}

DistanceJointSetMaxLength :: proc(joint: JointHandle, max_length: Meters) {
    b2d.DistanceJoint_SetLengthRange(joint,DistanceJointGetMinLength(joint), max_length)
}



SpringJointGetRestLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetLength(joint)
}

SpringJointGetMaxLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetMaxLength(joint)
}

SpringJointGetMinLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetMinLength(joint)
}

SpringJointGetCurrentLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetCurrentLength(joint)
}

SpringJointGetDampingRatio :: proc(joint: JointHandle) -> f32 {
    return b2d.DistanceJoint_GetSpringDampingRatio(joint)
}

SpringJointGetHertz :: proc(joint: JointHandle) -> Hertz {
    return b2d.DistanceJoint_GetSpringHertz(joint)
}

SpringJointSetRestLength :: proc(joint: JointHandle, length: Meters) {
    b2d.DistanceJoint_SetLength(joint, length)
}

SpringJointSetMinLength :: proc(joint: JointHandle, min_length: Meters) {
    b2d.DistanceJoint_SetLengthRange(joint, min_length, DistanceJointGetMaxLength(joint))
}

SpringJointSetMaxLength :: proc(joint: JointHandle, max_length: Meters) {
    b2d.DistanceJoint_SetLengthRange(joint,DistanceJointGetMinLength(joint), max_length)
}

SpringJointSetDampingRatio :: proc(joint: JointHandle, damping_ratio: f32) {
    b2d.DistanceJoint_SetSpringDampingRatio(joint, damping_ratio)
}

SpringJointSetHertz :: proc(joint: JointHandle, hertz: Hertz){
    b2d.DistanceJoint_SetSpringHertz(joint, hertz)
}



LinearActuatorJointGetRestLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetLength(joint)
}

LinearActuatorJointGetMaxLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetMaxLength(joint)
}

LinearActuatorJointGetMinLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetMinLength(joint)
}

LinearActuatorJointGetCurrentLength :: proc(joint: JointHandle) -> Meters {
    return b2d.DistanceJoint_GetCurrentLength(joint)
}

LinearActuatorJointGetSpeed :: proc(joint: JointHandle) -> MetersPerSecond {
    return b2d.DistanceJoint_GetMotorSpeed(joint)
}

LinearActuatorJointGetMaxForce :: proc(joint: JointHandle) -> Newtons {
    return b2d.DistanceJoint_GetMotorForce(joint)
}

LinearActuatorJointSetRestLength :: proc(joint: JointHandle, length: Meters) {
    b2d.DistanceJoint_SetLength(joint, length)
}

LinearActuatorJointSetMinLength :: proc(joint: JointHandle, min_length: Meters) {
    b2d.DistanceJoint_SetLengthRange(joint, min_length, DistanceJointGetMaxLength(joint))
}

LinearActuatorJointSetMaxLength :: proc(joint: JointHandle, max_length: Meters) {
    b2d.DistanceJoint_SetLengthRange(joint,DistanceJointGetMinLength(joint), max_length)
}

LinearActuatorJointSetSpeed :: proc(joint: JointHandle, speed: MetersPerSecond) {
    b2d.DistanceJoint_SetMotorSpeed(joint, speed)
}

LinearActuatorJointSetMaxForce :: proc(joint: JointHandle, force: Newtons) {
    b2d.DistanceJoint_SetMaxMotorForce(joint, force)
}