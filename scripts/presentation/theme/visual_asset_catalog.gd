extends RefCounted
class_name VisualAssetCatalog

const FONT_FREDOKA_PATH := "res://assets/third_party/google-fonts/Fredoka/Fredoka-wdth-wght.ttf"

const PANEL_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Extra/Default/input_outline_rectangle.png")
const BUTTON_PRIMARY_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Blue/Default/button_rectangle_depth_gloss.png")
const BUTTON_SECONDARY_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Yellow/Default/button_rectangle_depth_gloss.png")
const BUTTON_DANGER_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Red/Default/button_rectangle_depth_gloss.png")

const ICON_PLAY_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Extra/Default/icon_play_dark.png")
const ICON_REPEAT_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Extra/Default/icon_repeat_dark.png")
const ICON_BACK_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Blue/Default/arrow_basic_w.png")

const GEM_YELLOW_TEXTURE = preload("res://assets/third_party/Sylly/PNG/Medium/Gem Type1 Yellow.png")
const GEM_RED_TEXTURE = preload("res://assets/third_party/Sylly/PNG/Medium/Gem Type2 Red.png")
const GEM_GREEN_TEXTURE = preload("res://assets/third_party/Sylly/PNG/Medium/Gem Type3 Green.png")
const GEM_BLUE_TEXTURE = preload("res://assets/third_party/Sylly/PNG/Medium/Gem Type4 Blue.png")

const SPECIAL_HORIZONTAL_TEXTURE_PATH := "res://assets/third_party/kenney/particle-pack/PNG (Transparent)/Rotated/trace_05_rotated.png"
const SPECIAL_VERTICAL_TEXTURE_PATH := "res://assets/third_party/kenney/particle-pack/PNG (Transparent)/trace_05.png"
const SPECIAL_RAINBOW_TEXTURE_PATH := "res://assets/third_party/kenney/particle-pack/PNG (Transparent)/magic_05.png"

const OBSTACLE_BOX_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Grey/Default/icon_square.png")
const OBSTACLE_ICE_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Blue/Default/icon_circle.png")
const OBSTACLE_GRASS_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Green/Default/icon_checkmark.png")
const OBSTACLE_DENSE_GRASS_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Red/Default/icon_cross.png")

const BUTTON_PRIMARY := "button_primary"
const BUTTON_SECONDARY := "button_secondary"
const BUTTON_DANGER := "button_danger"

const ICON_PLAY := "icon_play"
const ICON_REPEAT := "icon_repeat"
const ICON_BACK := "icon_back"

const SPECIAL_HORIZONTAL := "special_horizontal"
const SPECIAL_VERTICAL := "special_vertical"
const SPECIAL_RAINBOW := "special_rainbow"

const OBSTACLE_BOX := "box"
const OBSTACLE_ICE := "ice"
const OBSTACLE_GRASS := "grass"
const OBSTACLE_DENSE_GRASS := "dense_grass"

const DARK_TEXT_COLOR = Color("2a1b12")

static var _font_cache: Dictionary = {}
static var _texture_cache: Dictionary = {}


static func title_font() -> FontFile:
    return _load_font_file(FONT_FREDOKA_PATH)


static func body_font() -> FontFile:
    return _load_font_file(FONT_FREDOKA_PATH)


static func panel_texture() -> Texture2D:
    return PANEL_TEXTURE


static func button_texture(kind: String) -> Texture2D:
    match kind:
        BUTTON_PRIMARY:
            return BUTTON_PRIMARY_TEXTURE
        BUTTON_DANGER:
            return BUTTON_DANGER_TEXTURE
        _:
            return BUTTON_SECONDARY_TEXTURE


static func icon_texture(kind: String) -> Texture2D:
    match kind:
        ICON_PLAY:
            return ICON_PLAY_TEXTURE
        ICON_REPEAT:
            return ICON_REPEAT_TEXTURE
        ICON_BACK:
            return ICON_BACK_TEXTURE
        _:
            return null


static func text_color_dark() -> Color:
    return DARK_TEXT_COLOR


static func gem_texture(color_id: String) -> Texture2D:
    match color_id:
        "yellow":
            return GEM_YELLOW_TEXTURE
        "red":
            return GEM_RED_TEXTURE
        "green":
            return GEM_GREEN_TEXTURE
        "blue":
            return GEM_BLUE_TEXTURE
        _:
            return GEM_YELLOW_TEXTURE


static func piece_texture(color_id: String, special_type: String = "") -> Texture2D:
    match special_type:
        "missile_horizontal":
            return special_texture(SPECIAL_HORIZONTAL)
        "missile_vertical":
            return special_texture(SPECIAL_VERTICAL)
        "rainbow":
            return special_texture(SPECIAL_RAINBOW)
        _:
            return gem_texture(color_id)


static func piece_badge_texture(_color_id: String, _special_type: String = "") -> Texture2D:
    return null


static func special_texture(kind: String) -> Texture2D:
    match kind:
        SPECIAL_HORIZONTAL:
            return _load_texture_file(SPECIAL_HORIZONTAL_TEXTURE_PATH)
        SPECIAL_VERTICAL:
            return _load_texture_file(SPECIAL_VERTICAL_TEXTURE_PATH)
        SPECIAL_RAINBOW:
            return _load_texture_file(SPECIAL_RAINBOW_TEXTURE_PATH)
        _:
            return null


static func special_texture_for_type(special_type: String) -> Texture2D:
    match special_type:
        "missile_horizontal":
            return special_texture(SPECIAL_HORIZONTAL)
        "missile_vertical":
            return special_texture(SPECIAL_VERTICAL)
        "rainbow":
            return special_texture(SPECIAL_RAINBOW)
        _:
            return null


static func obstacle_texture(kind: String) -> Texture2D:
    match kind:
        OBSTACLE_BOX:
            return OBSTACLE_BOX_TEXTURE
        OBSTACLE_ICE:
            return OBSTACLE_ICE_TEXTURE
        OBSTACLE_GRASS:
            return OBSTACLE_GRASS_TEXTURE
        OBSTACLE_DENSE_GRASS:
            return OBSTACLE_DENSE_GRASS_TEXTURE
        _:
            return null


static func obstacle_texture_for_type(obstacle_type: String) -> Texture2D:
    return obstacle_texture(obstacle_type)


static func _load_font_file(path: String) -> FontFile:
    if _font_cache.has(path):
        return _font_cache[path]

    var absolute_path: String = ProjectSettings.globalize_path(path)
    if not FileAccess.file_exists(absolute_path):
        return null

    var font_data: PackedByteArray = FileAccess.get_file_as_bytes(absolute_path)
    if font_data.is_empty():
        return null

    var font := FontFile.new()
    font.data = font_data
    font.allow_system_fallback = true
    _font_cache[path] = font
    return font


static func _load_texture_file(path: String) -> Texture2D:
    if _texture_cache.has(path):
        return _texture_cache[path]

    var absolute_path: String = ProjectSettings.globalize_path(path)
    if not FileAccess.file_exists(absolute_path):
        return null

    var image: Image = Image.load_from_file(absolute_path)
    if image == null or image.is_empty():
        return null

    var texture: Texture2D = ImageTexture.create_from_image(image)
    _texture_cache[path] = texture
    return texture
