package Physics


import "../../Types"
import "../../Util"
import b2d "vendor:box2d"


JointHandle :: b2d.JointId



/*
 * CreateDistanceJoint creates a distance joint between two objects.
 * @param world the physics world
 * @param obj_a first object
 * @param obj_b second object
 * @param anchor_a local anchor point on obj_a
 * @param anchor_b local anchor point on obj_b
 * @param rest_length the target distance between the anchors
 * @param min_length minimum allowed distance
 * @param max_length maximum allowed distance
 * @param handle_collision whether the connected bodies should collide
 * @return JointHandle handle to the created joint
 */
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
    jointDef.localAnchorA = anchor_a
    jointDef.localAnchorB = anchor_b
    return b2d.CreateDistanceJoint(cast(b2d.WorldId)world, jointDef^)
}

/*
 * CreateSpringJoint creates a spring joint between two objects.
 * @param world the physics world
 * @param obj_a first object
 * @param obj_b second object
 * @param anchor_a local anchor point on obj_a
 * @param anchor_b local anchor point on obj_b
 * @param rest_length the natural spring length
 * @param min_length minimum allowed distance
 * @param max_length maximum allowed distance
 * @param hertz frequency of the spring oscillation
 * @param damping damping ratio of the spring
 * @param handle_collision whether the connected bodies should collide
 * @return JointHandle handle to the created joint
 */
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
    jointDef.localAnchorA = anchor_a
    jointDef.localAnchorB = anchor_b
    return b2d.CreateDistanceJoint(cast(b2d.WorldId)world, jointDef^)
}

/*
 * CreateLinearActuatorJoint creates a linear actuator using a distance joint.
 * @param world the physics world
 * @param obj_a first object
 * @param obj_b second object
 * @param anchor_a local anchor point on obj_a
 * @param anchor_b local anchor point on obj_b
 * @param rest_length target distance when actuator is idle
 * @param min_length minimum allowed distance
 * @param max_length maximum allowed distance
 * @param max_force maximum motor force
 * @param speed speed of actuator movement
 * @param handle_collision whether the connected bodies should collide
 * @return JointHandle handle to the created joint
 */
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
    jointDef.localAnchorA = anchor_a
    jointDef.localAnchorB = anchor_b
    return b2d.CreateDistanceJoint(cast(b2d.WorldId)world, jointDef^)
}

/*
 * CreateMotorJoint creates a revolute motor joint between two objects.
 * @param world the physics world
 * @param obj_a first object
 * @param obj_b second object
 * @param anchor_a local anchor point on obj_a
 * @param anchor_b local anchor point on obj_b
 * @param motor_speed rotational speed of the motor
 * @param max_torque maximum torque applied by the motor
 * @param enable_motor whether the motor is enabled
 * @param handle_collision whether the connected bodies should collide
 * @return JointHandle handle to the created joint
 */
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

    jointDef.bodyIdA = cast(b2d.BodyId)obj_a
    jointDef.bodyIdB = cast(b2d.BodyId)obj_b
    jointDef.localAnchorA = anchor_a
    jointDef.localAnchorB = anchor_b
    jointDef.enableMotor = enable_motor
    jointDef.motorSpeed = motor_speed
    jointDef.maxMotorTorque = max_torque
    jointDef.collideConnected = handle_collision

    return b2d.CreateRevoluteJoint(cast(b2d.WorldId)world, jointDef^)
}

/*
 * DestroyJoint destroys a previously created joint.
 * @param joint handle to the joint
 */
DestroyJoint :: proc(joint: JointHandle) {
    b2d.DestroyJoint(joint)
}

/* -------- Distance Joint Getters -------- */

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

/* -------- Distance Joint Setters -------- */

DistanceJointSetRestLength :: proc(joint: JointHandle, length: Meters) {
    b2d.DistanceJoint_SetLength(joint, length)
}

DistanceJointSetMinLength :: proc(joint: JointHandle, min_length: Meters) {
    b2d.DistanceJoint_SetLengthRange(joint, min_length, DistanceJointGetMaxLength(joint))
}

DistanceJointSetMaxLength :: proc(joint: JointHandle, max_length: Meters) {
    b2d.DistanceJoint_SetLengthRange(joint,DistanceJointGetMinLength(joint), max_length)
}

/* -------- Spring Joint Getters -------- */

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

/* -------- Spring Joint Setters -------- */

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

/* -------- Linear Actuator Joint Getters -------- */

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

/* -------- Linear Actuator Joint Setters -------- */

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

/* -------- Motor Joint Getters & Setters -------- */

MotorJointGetEnabled :: proc(joint: JointHandle) -> bool {
    return b2d.RevoluteJoint_IsMotorEnabled(joint)
}

MotorJointGetCurrentAngle :: proc(joint: JointHandle) -> Radians {
    return b2d.RevoluteJoint_GetAngle(joint)
}

MotorJointGetSpeed :: proc(joint: JointHandle) -> RadiansPerSecond {
    return b2d.RevoluteJoint_GetMotorSpeed(joint)
}

MotorJointGetMaxTorque :: proc(joint: JointHandle) -> NewtonMeters {
    return b2d.RevoluteJoint_GetMotorTorque(joint)
}

MotorJointSetEnabled :: proc(joint: JointHandle, enabled: bool) {
    b2d.RevoluteJoint_EnableMotor(joint, enabled)
}

MotorJointSetSpeed :: proc(joint: JointHandle, speed: RadiansPerSecond) {
   b2d.RevoluteJoint_SetMotorSpeed(joint, speed)
}

MotorJointSetMaxTourque :: proc(joint: JointHandle, max_torque: NewtonMeters) {
    b2d.RevoluteJoint_SetMaxMotorTorque(joint, max_torque)
}
