package UI

import "vendor:sdl2/ttf"
import "../../Types"
import "../../internal_libs/MONT"
import "../../Util"



@(private="package")
HandleToNode :: proc(handle: ElementHandle, $T: typeid) -> ^MONT.Node(T) {
    return transmute(^MONT.Node(T))handle._internal
}

@(private="package")
NodeToHandle :: proc(node: ^MONT.Node($T)) -> ElementHandle {
    return ElementHandle{_internal = node}
}

@(private="package")
InitUITree :: proc(tree: ^MONT.MONT(Element)) {
    err := MONT.Init(tree)
    if err != .None {
        Util.Log(.ERROR, "MAGMA_2D_UI", "INIT_UI_TREE", "Allocation error: %s", err)
    }
}

@(private="package")
DestroyUITree :: proc(tree: ^MONT.MONT(Element)) {
    MONT.Shutdown(tree)
}

@(private="package")
CreateRootNode :: proc(tree: ^MONT.MONT(Element), data: Element) -> ^MONT.Node(Element) {
    return MONT.CreateNode(tree, nil, data)
}

@(private="package")
CreateNodeWithParent :: proc(tree: ^MONT.MONT(Element), parent: ^MONT.Node(Element), data: Element) -> ^MONT.Node(Element) {
    return MONT.CreateNode(tree, parent, data)
}

@(private="package")
CreateNode :: proc {
    CreateRootNode,
    CreateNodeWithParent
}

ElementGetPos :: proc(handle: ElementHandle) -> Types.Vector2f {
    node := HandleToNode(handle, Element)

    return (cast(^BaseElement)&node.data).pos
}

ElementGetSize :: proc(handle: ElementHandle) -> (width: f32, height: f32) {
        node := HandleToNode(handle, Element)
        size := (cast(^BaseElement)&node.data).size

        return size.x, size.y
}

ElementIsActive :: proc(handle: ElementHandle) -> bool {
    node := HandleToNode(handle, Element)
    return (cast(^BaseElement)&node.data).is_active
}

ElementIsFocused :: proc(handle: ElementHandle) -> bool {
    node := HandleToNode(handle, Element)
    return (cast(^BaseElement)&node.data).is_focused
}

TextElementGetText :: proc(handle: ElementHandle) -> (bool, string) {
    node := HandleToNode(handle, Element)

    #partial switch v in node.data {
        case Text:
            return true, v.text

        case :
            Util.Log(.WARN, "MAGMA_2D_UI", "TEXT_ELEMENT_GET_TEXT", "Element resolved from handle was not a Text element")
            return false, ""
    }

}

TextElementGetFont :: proc(handle: ElementHandle) -> (bool, ^ttf.Font) {
    node := HandleToNode(handle, Element)
    
    #partial switch v in node.data {
        case Text:
            return true, v.font

        case :
            Util.Log(.WARN, "MAGMA_2D_UI", "TEXT_ELEMENT_GET_FONT", "Element resolved from handle was not a Text element")
            return false, nil
    }
}

TextElementGetColor :: proc(handle: ElementHandle) -> (bool, Types.Color) {
    node := HandleToNode(handle, Element)

    #partial switch v in node.data {
        case Text:
            return true, v.color
        case :
            Util.Log(.WARN, "MAGMA_2D_UI", "TEXT_ELEMENT_GET_FONT", "Element resolved from handle was not a Text element")
            return false, #simd[4]u8{0, 0, 0, 0}
    }
}
