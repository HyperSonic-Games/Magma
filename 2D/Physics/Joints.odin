package Physics

import "../../Types"
import "../../Util"
import b2d "vendor:box2d"

JointHandle :: b2d.JointId

/*
 * CreateDistanceJoint creates a fixed-length joint between two objects.
 * The distance between anchor points on the two bodies is constrained.
 * @param world Physics world
 * @param obj_a First object
 * @param obj_b Second object
 * @param anchor_a Local anchor point on obj_a
 * @param anchor_b Local anchor point on obj_b
 * @param rest_length Target length of the joint
 * @param min_length Minimum allowed length
 * @param max_length Maximum allowed length
 * @param handle_collision Whether connected bodies should collide
 * @return JointHandle Handle to the created joint
 */
CreateDistanceJoint :: proc(
    world: World,
    obj_a: Obj,
    obj_b: Obj,
    anchor_a: Types.Vector2f,
    anchor_b: Types.Vector2f,
    rest_length: Types.Meters,
    min_length: Types.Meters,
    max_length: Types.Meters,
    handle_collision: bool = true
) -> JointHandle {
    jointDef := new(b2d.DistanceJointDef)
    defer free(jointDef)
    jointDef.bodyIdA = obj_a
    jointDef.bodyIdB = obj_b
    jointDef.collideConnected = handle_collision
    jointDef.length = rest_length
    jointDef.maxLength = max_length
    jointDef.minLength = min_length
    jointDef.enableLimit = true
    jointDef.enableMotor = false
    jointDef.enableSpring = false
    jointDef.localAnchorA = anchor_a
    jointDef.localAnchorB = anchor_b
    return b2d.CreateDistanceJoint(world, jointDef^)
}

/*
 * CreateSpringJoint creates a spring-like distance joint.
 * Oscillates based on the provided hertz and damping ratio.
 * @param hertz Frequency of spring oscillation
 * @param damping Damping ratio for spring motion
 * @param handle_collision Whether connected bodies should collide
 */
CreateSpringJoint :: proc(
    world: World,
    obj_a: Obj,
    obj_b: Obj,
    anchor_a: Types.Vector2f,
    anchor_b: Types.Vector2f,
    rest_length: Types.Meters,
    min_length: Types.Meters,
    max_length: Types.Meters,
    hertz: Types.Hertz,
    damping: f32,
    handle_collision: bool = true
) -> JointHandle {
    jointDef := new(b2d.DistanceJointDef)
    defer free(jointDef)
    jointDef.bodyIdA = obj_a
    jointDef.bodyIdB = obj_b
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
    return b2d.CreateDistanceJoint(world, jointDef^)
}

/*
 * CreateLinearActuatorJoint creates a distance joint acting as a linear actuator.
 * Motor properties move the actuator between min and max lengths.
 * @param max_force Maximum motor force
 * @param speed Speed of actuator movement
 * @param handle_collision Whether connected bodies should collide
 */
CreateLinearActuatorJoint :: proc(
    world: World,
    obj_a: Obj,
    obj_b: Obj,
    anchor_a: Types.Vector2f,
    anchor_b: Types.Vector2f,
    rest_length: Types.Meters,
    min_length: Types.Meters,
    max_length: Types.Meters,
    max_force: Types.Newtons,
    speed: Types.MetersPerSecond,
    handle_collision: bool = true
) -> JointHandle {
    jointDef := new(b2d.DistanceJointDef)
    defer free(jointDef)
    jointDef.bodyIdA = obj_a
    jointDef.bodyIdB = obj_b
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
    return b2d.CreateDistanceJoint(world, jointDef^)
}

/*
 * CreateMotorJoint creates a revolute motor joint between two objects.
 * Rotational movement is controlled by motor speed and max torque.
 * @param motor_speed Rotational speed of the motor
 * @param max_torque Maximum torque applied by the motor
 * @param enable_motor Whether motor is enabled
 * @param handle_collision Whether connected bodies should collide
 */
CreateMotorJoint :: proc(
    world: World,
    obj_a: Obj,
    obj_b: Obj,
    anchor_a: Types.Vector2f,
    anchor_b: Types.Vector2f,
    motor_speed: Types.RadiansPerSecond,
    max_torque: Types.NewtonMeters,
    enable_motor: bool = true,
    handle_collision: bool = true,
) -> JointHandle {
    jointDef := new(b2d.RevoluteJointDef)
    defer free(jointDef)
    jointDef.bodyIdA = obj_a
    jointDef.bodyIdB = obj_b
    jointDef.localAnchorA = anchor_a
    jointDef.localAnchorB = anchor_b
    jointDef.enableMotor = enable_motor
    jointDef.motorSpeed = motor_speed
    jointDef.maxMotorTorque = max_torque
    jointDef.collideConnected = handle_collision
    return b2d.CreateRevoluteJoint(world, jointDef^)
}

/*
 * DestroyJoint removes a joint from the physics world.
 * @param joint Handle of the joint to destroy
 */
DestroyJoint :: proc(joint: JointHandle) {
    b2d.DestroyJoint(joint)
}

/* -------- Distance Joint Getters -------- */

/*
 * DistanceJointGetRestLength returns the rest length of a distance joint.
 * @param joint Handle to the distance joint
 * @return Current rest length of the joint
 */
DistanceJointGetRestLength :: proc(joint: JointHandle) -> Types.Meters {
    return b2d.DistanceJoint_GetLength(joint)
}

/*
 * DistanceJointGetMaxLength returns the maximum allowed length of a distance joint.
 * @param joint Handle to the distance joint
 * @return Maximum length of the joint
 */
DistanceJointGetMaxLength :: proc(joint: JointHandle) -> Types.Meters {
    return b2d.DistanceJoint_GetMaxLength(joint)
}

/*
 * DistanceJointGetMinLength returns the minimum allowed length of a distance joint.
 * @param joint Handle to the distance joint
 * @return Minimum length of the joint
 */
DistanceJointGetMinLength :: proc(joint: JointHandle) -> Types.Meters {
    return b2d.DistanceJoint_GetMinLength(joint)
}

/*
 * DistanceJointGetCurrentLength returns the current length of a distance joint.
 * @param joint Handle to the distance joint
 * @return Current distance between the two anchor points
 */
DistanceJointGetCurrentLength :: proc(joint: JointHandle) -> Types.Meters {
    return b2d.DistanceJoint_GetCurrentLength(joint)
}

/* -------- Distance Joint Setters -------- */

/*
 * DistanceJointSetRestLength sets the rest length of a distance joint.
 * @param joint Handle to the distance joint
 * @param length New rest length to set
 */
DistanceJointSetRestLength :: proc(joint: JointHandle, length: Types.Meters) {
    b2d.DistanceJoint_SetLength(joint, length)
}

/*
 * DistanceJointSetMinLength sets the minimum allowed length of a distance joint.
 * The maximum length remains unchanged.
 * @param joint Handle to the distance joint
 * @param min_length New minimum length to set
 */
DistanceJointSetMinLength :: proc(joint: JointHandle, min_length: Types.Meters) {
    b2d.DistanceJoint_SetLengthRange(joint, min_length, DistanceJointGetMaxLength(joint))
}

/*
 * DistanceJointSetMaxLength sets the maximum allowed length of a distance joint.
 * The minimum length remains unchanged.
 * @param joint Handle to the distance joint
 * @param max_length New maximum length to set
 */
DistanceJointSetMaxLength :: proc(joint: JointHandle, max_length: Types.Meters) {
    b2d.DistanceJoint_SetLengthRange(joint, DistanceJointGetMinLength(joint), max_length)
}
