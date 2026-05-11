package UI

import "vendor:sdl2"
import "vendor:sdl2/ttf"
import "../../Types/"
import "../../Util"
import "../../internal_libs/MONT"

BaseElement :: struct {
    pos: Types.Vector2f,
    size: Types.Vector2f, // x is width y is height

    is_active: bool,
    is_hovered: bool,
    is_focused: bool,
}

Text :: struct {
    using element: BaseElement,

    text: string,
    font: ^ttf.Font,
    color: Types.Color,
}

Button :: struct {
    using element: BaseElement,

    text: string,
    font: ^ttf.Font,
    text_color: Types.Color,
    bg_color: Types.Color,

    pressed: bool,
}

Image :: struct {
    using element: BaseElement,

    texture: sdl2.Texture,
    tint: Types.Color,
}

Panel :: struct {
    using element: BaseElement,

    bg_color: Types.Color,
    border_color: Types.Color,
    border: i32,
}

Checkbox :: struct {
    using element: BaseElement,

    checked: bool,
    box_color: Types.Color,
    check_color: Types.Color,
}

Slider :: struct {
    using element: BaseElement,

    value: f32, // 0..1
    bar_color: Types.Color,
    knob_color: Types.Color,
}

TextInput :: struct {
    using element: BaseElement,

    buffer: string,
    font: ^ttf.Font,
    text_color: Types.Color,

    cursor: i32,
    active: bool,
}

Element :: union {
    Text,
    Button,
    Image,
    Panel,
    Checkbox,
    Slider,
    TextInput,
}


ElementHandle :: struct {
    _internal: rawptr,
}

UIContext :: struct {
    _internal: rawptr,
    has_root: bool
}

NewUI :: proc() -> ^UIContext {
    ctx := new(UIContext)
    ctx.has_root = false
    ctx._internal = new(MONT.MONT(Element))
    InitUITree(cast(^MONT.MONT(Element))ctx._internal)
    return ctx
}

DeleteUI :: proc(ctx: ^UIContext) {
    DestroyUITree(cast(^MONT.MONT(Element))ctx._internal)
}

CreateTextElement :: proc(ctx: ^UIContext, element: Text, parent: ElementHandle) -> ElementHandle {
    if element == {} {
        Util.Log(.ERROR, "MAGMA_2D_UI", "CREATE_TEXT_ELEMENT", "expected an element got {}")
        return {}
    }

    node: ^MONT.Node(Element)

    if !ctx.has_root {
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, element)
        ctx.has_root = true
    } else {
        p_node := HandleToNode(parent, Element)
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, p_node, element)
    }

    return NodeToHandle(node)
}

CreateButtonElement :: proc(ctx: ^UIContext, element: Button, parent: ElementHandle) -> ElementHandle {
    if element == {} {
        Util.Log(.ERROR, "MAGMA_2D_UI", "CREATE_BUTTON_ELEMENT", "expected an element got {}")
        return {}
    }

    node: ^MONT.Node(Element)

    if !ctx.has_root {
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, element)
        ctx.has_root = true
    } else {
        p_node := HandleToNode(parent, Element)
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, p_node, element)
    }

    return NodeToHandle(node)
}

CreateImageElement :: proc(ctx: ^UIContext, element: Image, parent: ElementHandle) -> ElementHandle {
    if element == {} {
        Util.Log(.ERROR, "MAGMA_2D_UI", "CREATE_IMAGE_ELEMENT", "expected an element got {}")
        return {}
    }

    node: ^MONT.Node(Element)

    if !ctx.has_root {
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, element)
        ctx.has_root = true
    } else {
        p_node := HandleToNode(parent, Element)
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, p_node, element)
    }

    return NodeToHandle(node)
}

CreatePanelElement :: proc(ctx: ^UIContext, element: Panel, parent: ElementHandle) -> ElementHandle {
    if element == {} {
        Util.Log(.ERROR, "MAGMA_2D_UI", "CREATE_TEXT_ELEMENT", "expected an element got {}")
        return {}
    }

    node: ^MONT.Node(Element)

    if !ctx.has_root {
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, element)
        ctx.has_root = true
    } else {
        p_node := HandleToNode(parent, Element)
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, p_node, element)
    }

    return NodeToHandle(node)
}

CreateCheckBoxElement :: proc(ctx: ^UIContext, element: Checkbox, parent: ElementHandle) -> ElementHandle {
    if element == {} {
        Util.Log(.ERROR, "MAGMA_2D_UI", "CREATE_TEXT_ELEMENT", "expected an element got {}")
        return {}
    }

    node: ^MONT.Node(Element)

    if !ctx.has_root {
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, element)
        ctx.has_root = true
    } else {
        p_node := HandleToNode(parent, Element)
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, p_node, element)
    }

    return NodeToHandle(node)
}

CreateSliderElement :: proc(ctx: ^UIContext, element: Slider, parent: ElementHandle) -> ElementHandle {
    if element == {} {
        Util.Log(.ERROR, "MAGMA_2D_UI", "CREATE_TEXT_ELEMENT", "expected an element got {}")
        return {}
    }

    node: ^MONT.Node(Element)

    if !ctx.has_root {
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, element)
        ctx.has_root = true
    } else {
        p_node := HandleToNode(parent, Element)
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, p_node, element)
    }

    return NodeToHandle(node)
}

CreateTextInputElement :: proc(ctx: ^UIContext, element: TextInput, parent: ElementHandle) -> ElementHandle {
    if element == {} {
        Util.Log(.ERROR, "MAGMA_2D_UI", "CREATE_TEXT_ELEMENT", "expected an element got {}")
        return {}
    }

    node: ^MONT.Node(Element)

    if !ctx.has_root {
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, element)
        ctx.has_root = true
    } else {
        p_node := HandleToNode(parent, Element)
        node = CreateNode(cast(^MONT.MONT(Element))ctx._internal, p_node, element)
    }

    return NodeToHandle(node)
}