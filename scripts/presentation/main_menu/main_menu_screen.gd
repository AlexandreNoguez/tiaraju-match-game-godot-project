extends Control
class_name MainMenuScreen

signal play_requested(level_id: String)

@onready var _background: ColorRect = $Background
@onready var _ground_band: ColorRect = $GroundBand
@onready var _sun_disc: Panel = $SunDisc
@onready var _leaf_cluster_left: Panel = $LeafClusterLeft
@onready var _leaf_cluster_right: Panel = $LeafClusterRight
@onready var _title_label: Label = $MarginContainer/RootColumn/HeaderRow/TitleColumn/TitleLabel
@onready var _subtitle_label: Label = $MarginContainer/RootColumn/HeaderRow/TitleColumn/SubtitleLabel
@onready var _current_level_label: Label = $MarginContainer/RootColumn/CurrentLevelPanel/VBoxContainer/CurrentLevelLabel
@onready var _highest_unlocked_label: Label = $MarginContainer/RootColumn/CurrentLevelPanel/VBoxContainer/HighestUnlockedLabel
@onready var _last_completed_label: Label = $MarginContainer/RootColumn/CurrentLevelPanel/VBoxContainer/LastCompletedLabel
@onready var _progress_label: Label = $MarginContainer/RootColumn/CurrentLevelPanel/VBoxContainer/ProgressLabel
@onready var _coins_label: Label = $MarginContainer/RootColumn/EconomyPanel/VBoxContainer/CoinsLabel
@onready var _status_label: Label = $MarginContainer/RootColumn/StatusLabel
@onready var _play_button: Button = $MarginContainer/RootColumn/PlayButton
@onready var _profile_button: Button = $MarginContainer/RootColumn/ProfilePanel/HBoxContainer/VBoxContainer/ProfileButton
@onready var _events_button: Button = $MarginContainer/RootColumn/EventsPanel/VBoxContainer/EventsButton
@onready var _shop_button: Button = $MarginContainer/RootColumn/EconomyPanel/VBoxContainer/ShopButton
@onready var _settings_button: Button = $MarginContainer/RootColumn/HeaderRow/SettingsButton
@onready var _profile_panel: PanelContainer = $MarginContainer/RootColumn/ProfilePanel
@onready var _events_panel: PanelContainer = $MarginContainer/RootColumn/EventsPanel
@onready var _current_level_panel: PanelContainer = $MarginContainer/RootColumn/CurrentLevelPanel
@onready var _economy_panel: PanelContainer = $MarginContainer/RootColumn/EconomyPanel
@onready var _avatar_placeholder: Panel = $MarginContainer/RootColumn/ProfilePanel/HBoxContainer/AvatarPlaceholder

var _level_data: Dictionary = {}
var _progress_payload: Dictionary = {}
var _status_message: String = "Beta offline-first: avatar, eventos, perfil e configuracoes seguem como placeholder."


func setup(level_data: Dictionary, progress_payload: Dictionary = {}) -> void:
    _level_data = level_data.duplicate(true)
    _progress_payload = progress_payload.duplicate(true)


func _ready() -> void:
    _apply_visual_theme()
    _play_button.pressed.connect(_on_play_pressed)
    _profile_button.pressed.connect(_on_profile_pressed)
    _events_button.pressed.connect(_on_events_pressed)
    _shop_button.pressed.connect(_on_shop_pressed)
    _settings_button.pressed.connect(_on_settings_pressed)
    _refresh_view()


func _refresh_view() -> void:
    var level_id: String = String(_level_data.get("id", "level_001"))
    var level_name: String = String(_level_data.get("name", "Primeira fase"))
    var completed_levels: Array = _progress_payload.get("completed_levels", [])
    var coins: int = int(_progress_payload.get("coins", 0))
    var highest_unlocked_level_id: String = String(_progress_payload.get("highest_unlocked_level_id", level_id))
    var last_completed_level_id: String = String(_progress_payload.get("last_completed_level_id", ""))

    _current_level_label.text = "Fase atual: %s" % _build_level_title(level_id, level_name)
    _highest_unlocked_label.text = "Maior desbloqueada: %s" % _build_level_id_label(highest_unlocked_level_id)
    _last_completed_label.text = "Ultima concluida: %s" % _build_level_id_label(last_completed_level_id)
    _progress_label.text = "Fases concluidas no aparelho: %s" % completed_levels.size()
    _coins_label.text = "Moedas: %s" % coins
    _status_label.text = _status_message


func _build_level_title(level_id: String, level_name: String) -> String:
    if not level_id.begins_with("level_"):
        return level_name

    var numeric_part: String = level_id.trim_prefix("level_")
    if not numeric_part.is_valid_int():
        return level_name

    return "%d - %s" % [int(numeric_part), level_name]


func _build_level_id_label(level_id: String) -> String:
    if level_id == "":
        return "nenhuma"

    if not level_id.begins_with("level_"):
        return level_id

    var numeric_part: String = level_id.trim_prefix("level_")
    if not numeric_part.is_valid_int():
        return level_id

    return str(int(numeric_part))


func _on_play_pressed() -> void:
    emit_signal("play_requested", String(_level_data.get("id", "level_001")))


func _on_profile_pressed() -> void:
    _status_message = "Perfil permanece como placeholder no beta offline, sem login ou foto."
    _refresh_view()


func _on_events_pressed() -> void:
    _status_message = "Eventos ficam para depois do beta. Por enquanto, o foco e validar a progressao linear."
    _refresh_view()


func _on_shop_pressed() -> void:
    _status_message = "O shop entra no pos-beta. As moedas ja aparecem no home como placeholder da economia futura."
    _refresh_view()


func _on_settings_pressed() -> void:
    _status_message = "Configuracoes entram como placeholder nesta etapa. Save local continua sendo a fonte de progresso."
    _refresh_view()


func _apply_visual_theme() -> void:
    var palette: Dictionary = {
        "background": Color("f4e0b4"),
        "ground": Color("d18a4b"),
        "sun": Color("ffd973"),
        "leaf_primary": Color("4a8a53"),
        "leaf_secondary": Color("2d5d3a"),
        "panel": Color(1, 0.97, 0.9, 0.86),
        "panel_border": Color("9a5b32"),
        "title": Color("4a2917"),
        "body": Color("6a4a33"),
        "button": Color("c95f3d"),
        "button_hover": Color("da724d"),
        "button_pressed": Color("a94e32"),
        "button_text": Color("fff9ef")
    }

    _background.color = palette["background"]
    _ground_band.color = palette["ground"]
    _title_label.add_theme_color_override("font_color", palette["title"])
    _subtitle_label.add_theme_color_override("font_color", palette["body"])
    _current_level_label.add_theme_color_override("font_color", palette["title"])
    _highest_unlocked_label.add_theme_color_override("font_color", palette["body"])
    _last_completed_label.add_theme_color_override("font_color", palette["body"])
    _progress_label.add_theme_color_override("font_color", palette["body"])
    _coins_label.add_theme_color_override("font_color", palette["title"])
    _status_label.add_theme_color_override("font_color", palette["body"])

    _apply_panel_style(_sun_disc, palette["sun"], palette["sun"], 999)
    _apply_panel_style(_leaf_cluster_left, palette["leaf_primary"], palette["leaf_primary"], 160)
    _apply_panel_style(_leaf_cluster_right, palette["leaf_secondary"], palette["leaf_secondary"], 160)
    _apply_panel_style(_avatar_placeholder, Color("f7c86a"), palette["panel_border"], 40)

    for panel in [_profile_panel, _events_panel, _current_level_panel, _economy_panel]:
        _apply_panel_style(panel, palette["panel"], palette["panel_border"], 28)

    for button in [_play_button, _profile_button, _events_button, _shop_button, _settings_button]:
        _apply_button_style(button, palette["button"], palette["button_hover"], palette["button_pressed"], palette["button_text"])


func _apply_panel_style(target: Control, background_color: Color, border_color: Color, radius: int) -> void:
    var style := StyleBoxFlat.new()
    style.bg_color = background_color
    style.border_color = border_color
    style.border_width_left = 3
    style.border_width_top = 3
    style.border_width_right = 3
    style.border_width_bottom = 3
    style.corner_radius_top_left = radius
    style.corner_radius_top_right = radius
    style.corner_radius_bottom_right = radius
    style.corner_radius_bottom_left = radius

    var theme_key: String = "panel" if target is PanelContainer or target is Panel else "normal"
    target.add_theme_stylebox_override(theme_key, style)


func _apply_button_style(button: Button, base_color: Color, hover_color: Color, pressed_color: Color, text_color: Color) -> void:
    var normal := StyleBoxFlat.new()
    normal.bg_color = base_color
    normal.border_color = base_color.darkened(0.25)
    normal.border_width_left = 3
    normal.border_width_top = 3
    normal.border_width_right = 3
    normal.border_width_bottom = 3
    normal.corner_radius_top_left = 24
    normal.corner_radius_top_right = 24
    normal.corner_radius_bottom_right = 24
    normal.corner_radius_bottom_left = 24

    var hover := normal.duplicate()
    hover.bg_color = hover_color

    var pressed := normal.duplicate()
    pressed.bg_color = pressed_color

    button.add_theme_stylebox_override("normal", normal)
    button.add_theme_stylebox_override("hover", hover)
    button.add_theme_stylebox_override("pressed", pressed)
    button.add_theme_color_override("font_color", text_color)
    button.add_theme_color_override("font_hover_color", text_color)
    button.add_theme_color_override("font_pressed_color", text_color)
