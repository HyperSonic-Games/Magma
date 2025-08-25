package Physics

import "../../Types"
import "../../Util"
import b2d "vendor:box2d"

// --- Material registry ---
MaterialRegistry: map[string]Material

/*
 * GetMaterial retrieves a material from the registry.
 * @param name the string identifier of the material
 * @return the Material struct corresponding to the name
*/
GetMaterial :: proc(name: string) -> Material {
    return MaterialRegistry[name]
}

/*
 * RegisterMaterial adds a material to the registry.
 * @param name the string identifier for the material
 * @param mat the Material struct to register
*/
RegisterMaterial :: proc(name: string, mat: Material) {
    MaterialRegistry[name] = mat
}

/*
 * InitMatRegistry initializes the material registry at program start.
 * This is automatically called via @init.
*/
@init
InitMatRegistry :: proc() {
    MaterialRegistry = make(map[string]Material)
}

/*
 * DestroyMatRegistry clears the material registry.
 * Called via @fini. No explicit memory freeing needed because Odin maps are GC-managed.
*/
@fini
DestroyMatRegistry :: proc() {
    MaterialRegistry = make(map[string]Material)
}
