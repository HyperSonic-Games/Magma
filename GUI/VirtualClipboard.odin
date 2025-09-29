package GUI

import "core:encoding/base64"
import "../Util"

/*
Handle to an item in the clipboard.

NOTE:
- There is no guarantee that the handle remains valid.
- The clipboard can change at any time.
- Use the handle immediately after obtaining it and discard it once done.
*/
ClipboardItemHandle :: distinct uint

// A union representing all possible types of clipboard data.
ClipboardData :: union {
    string,  // Odin-managed string (stack or heap). Safe; memory is managed automatically.
    cstring, // Null-terminated C string (on the stack). Safe as long as it remains in scope.
    int,     // Signed integer (stack). Safe.
    uint,    // Unsigned integer (stack). Safe.
    rawptr,  // Raw pointer. Only this requires manual memory management.
    []byte,  // Byte array (stack). Safe; memory is automatically managed.
}

// A single clipboard item.
ClipboardItem :: struct {
    data: ClipboardData
    // NOTE: Only rawptr may need explicit memory management.
}

// Clipboard container storing multiple items.
Clipboard :: struct {
    data: [dynamic]ClipboardItem
    // NOTE: Destroying this struct does NOT free any memory for rawptr. Everything else is stack-managed.
}


@private
@(link_section="MAGMA_ENGINE_GLOBALS")
GLOBAL_CLIPBOARD: ^Clipboard

@init
@private
InitGlobalClipboard :: proc() {
    GLOBAL_CLIPBOARD = new(Clipboard)
    GLOBAL_CLIPBOARD.data = make([dynamic]ClipboardItem)
}

@fini
@private
DestroyGlobalClipboard :: proc() {
    // Only deletes the dynamic array and Clipboard struct.
    // rawptr items are NOT freed.
    delete(GLOBAL_CLIPBOARD.data)
    free(GLOBAL_CLIPBOARD)
}



// Create a new clipboard instance
CreateClipboard :: proc() -> ^Clipboard {
    cb: ^Clipboard = new(Clipboard)
    cb.data = make([dynamic]ClipboardItem)
    return cb
}

// Destroy a clipboard instance
DestroyClipboard :: proc(cb: ^Clipboard) {
    // Only deletes the dynamic array and the Clipboard struct.
    // Any rawptr items inside are NOT freed; caller must manage them.
    delete(cb.data)
    free(cb)
}



// Copy a ClipboardData item into a clipboard
Copy :: proc(data: ClipboardData, clipboard: ^Clipboard = GLOBAL_CLIPBOARD, ) -> ClipboardItemHandle {
    item: ClipboardItem
    item.data = data
    append(&clipboard.data, item)
    // Return a handle: index in the dynamic array
    return ClipboardItemHandle(len(clipboard.data) - 1)
}

// Paste a ClipboardData item from a clipboard using a handle
Paste :: proc(handle: ClipboardItemHandle, clipboard: ^Clipboard = GLOBAL_CLIPBOARD, ) -> ClipboardData {
    idx: int = cast(int)handle
    if idx < 0 || idx >= len(clipboard.data) {
        // Invalid handle: return an empty union
        return {}
    }
    return clipboard.data[idx].data
}
