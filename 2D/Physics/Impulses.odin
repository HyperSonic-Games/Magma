package Physics

import "../../Types"
import "../../Util"
import b2d "vendor:box2d"


Boom :: proc(world: World, position: Types.Vector2f, strength: f32, radius: f32, falloff: f32) {
    expl_def := b2d.DefaultExplosionDef()

    expl_def.position[0] = cast(f32)Types.Vector2fGetX(position)
    expl_def.position[1] = cast(f32)Types.Vector2fGetY(position)
    expl_def.radius = radius
    expl_def.impulsePerLength = strength
    expl_def.falloff = falloff
    b2d.World_Explode(cast(b2d.WorldId)world, expl_def)
}

