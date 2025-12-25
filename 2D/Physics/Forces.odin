package Physics

import "../../Types"
import "../../Util"
import b2d "vendor:box2d"


/*
 * Boom creates an explosion in the physics world
 * @param world The physics world
 * @param position The center position of the explosion
 * @param strength The force of the explosion
 * @param radius The radius affected by the explosion
 * @param falloff How the force decreases with distance
 */
Boom :: proc(world: World, position: Types.Vector2f, strength: f32, radius: Types.Meters, falloff: Types.Meters) {
    expl_def := b2d.DefaultExplosionDef()

    expl_def.position = position
    expl_def.radius = radius
    expl_def.impulsePerLength = strength
    expl_def.falloff = falloff
    b2d.World_Explode(world, expl_def)
}


/*
 * Impulse Applies a linear impulse to a body at its center of mass.
 * @param world The physics world
 * @param body The body to apply the impulse to in Ns
 * @param impulse The vector force to apply
 */
Impulse :: proc(world: World, body: Obj, impulse: Types.Vector2f) {
    b2d.Body_ApplyLinearImpulseToCenter(
        body, 
        {impulse[0], impulse[1]}, 
        true
    )
}

/*
 * Torque Applies a rotational impulse to a body.
 * @param world The physics world
 * @param body The body to apply the torque to
 * @param torque The magnitude of the rotational force
 */
Torque :: proc(world: World, body: Obj, torque: Types.NewtonMeters) {
    b2d.Body_ApplyTorque(
        body,
        torque,
        true
    )
}

/*
 * Move Instantly moves a body to a specific position and rotation.
 * WARNING: This is a VERY EXPENSIVE operation
 * and can disrupt the simulation if overused.
 * @param body The body to move
 * @param pos The target position
 * @param rot The target rotation
 */
Move :: proc(body: Obj, pos: Types.Vector2f, rot: Types.Radians) {
    b2d.Body_SetTransform(
        body, 
        {pos[0], pos[1]}, 
        b2d.MakeRot(rot)
    )
}