package Physics

import "core:mem"

PIXELS_TO_METERS : int : #config(magma_engine_pyhsics_pixels_to_meters, 32)
TLSF_ALLOCATOR_MEM_POOL_SIZE : int : #config(magma_engine_physics_tlsf_allocator_mem_pool_size_in_mb, 8) * mem.Megabyte
MAX_POLYGON_VERTS : int : #config(magma_engine_physics_max_polygon_verts, 8)