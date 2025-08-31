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
Boom :: proc(world: World, position: Types.Vector2f, strength: f32, radius: f32, falloff: f32) {
    expl_def := b2d.DefaultExplosionDef()

    expl_def.position[0] = cast(f32)Types.Vector2fGetX(position)
    expl_def.position[1] = cast(f32)Types.Vector2fGetY(position)
    expl_def.radius = radius
    expl_def.impulsePerLength = strength
    expl_def.falloff = falloff
    b2d.World_Explode(cast(b2d.WorldId)world, expl_def)
}


/*
 * Impulse Applies a linear impulse to a body at its center of mass.
 * @param world The physics world (required by Box2D API)
 * @param body The body to apply the impulse to
 * @param impulse The vector force to apply
 */
Impulse :: proc(world: World, body: Obj, impulse: Types.Vector2f) {
    b2d.Body_ApplyLinearImpulseToCenter(
        cast(b2d.BodyId)body, 
        cast(b2d.Vec2){cast(f32)Types.Vector2fGetX(impulse), cast(f32)Types.Vector2fGetY(impulse)}, 
        true
    )
}

/*
 * Torque Applies a rotational impulse (torque) to a body.
 * @param world The physics world (required by Box2D API)
 * @param body The body to apply the torque to
 * @param torque The magnitude of the rotational force
 */
Torque :: proc(world: World, body: Obj, torque: f32) {
    b2d.Body_ApplyTorque(
        cast(b2d.BodyId)body,
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
 * @param rot The target rotation in radians
 */
Move :: proc(body: Obj, pos: Types.Vector2f, rot: f32) {
    b2d.Body_SetTransform(
        cast(b2d.BodyId)body, 
        {cast(f32)Types.Vector2fGetX(pos), cast(f32)Types.Vector2fGetY(pos)}, 
        b2d.MakeRot(rot)
    )
}