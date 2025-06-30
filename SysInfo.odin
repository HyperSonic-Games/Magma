package Magma



import "Util"
import "core:simd"

@init
Platform :: proc() {
    Util.log(.INFO, "MAGMA_SYSINFO", "Magma is currently compiled for the %s operating system", ODIN_OS_STRING)
    Util.log(.INFO, "MAGMA_SYSINFO", "Magma is currently compiled for the %s arch", ODIN_ARCH_STRING)
    
    if simd.IS_EMULATED {
        Util.log(.INFO, "MAGMA_SYSINFO", "Magma is currently running with emulated simd support")
    } else {
        Util.log(.INFO, "MAGMA_SYSINFO", "Magma is currently running with native simd support")
    }

    
}

