package Physics

import "../../Types"
import "../../Util"
import b2d "vendor:box2d"

// --- Material registry ---
@private
@(link_section="MAGMA_ENGINE_GLOBALS")
MaterialRegistry: map[string]Material

Material :: b2d.SurfaceMaterial

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



@init
@private
InitMatRegistry :: proc() {
    MaterialRegistry = make(map[string]Material)
}

@fini
@private
DestroyMatRegistry :: proc() {
    delete(MaterialRegistry)
}
