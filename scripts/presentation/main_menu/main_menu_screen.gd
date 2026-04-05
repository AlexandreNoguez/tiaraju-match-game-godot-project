extends Control
class_name MainMenuScreen

signal play_requested(level_id: String)
signal playtest_level_requested(level_id: String)
signal reset_save_requested
signal audio_settings_changed(music_enabled: bool, sfx_enabled: bool)

const SOUND_CLICK_A = preload("res://assets/third_party/kenney/ui-pack/Sounds/click-a.ogg")
const SOUND_CLICK_B = preload("res://assets/third_party/kenney/ui-pack/Sounds/click-b.ogg")
const SOUND_SWITCH_A = preload("res://assets/third_party/kenney/ui-pack/Sounds/switch-a.ogg")
const SOUND_TAP_A = preload("res://assets/third_party/kenney/ui-pack/Sounds/tap-a.ogg")
const MUSIC_HOME_PATH = "res://assets/third_party/kenney/music-jingles/home.ogg"
const KENNEY_FONT_TITLE = preload("res://assets/third_party/kenney/ui-pack/Font/Kenney Future.ttf")
const KENNEY_FONT_BODY = preload("res://assets/third_party/kenney/ui-pack/Font/Kenney Future Narrow.ttf")
const KENNEY_PANEL_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Extra/Default/input_outline_rectangle.png")
const KENNEY_BUTTON_PRIMARY = preload("res://assets/third_party/kenney/ui-pack/PNG/Blue/Default/button_rectangle_depth_gloss.png")
const KENNEY_BUTTON_SECONDARY = preload("res://assets/third_party/kenney/ui-pack/PNG/Yellow/Default/button_rectangle_depth_gloss.png")
const KENNEY_BUTTON_DANGER = preload("res://assets/third_party/kenney/ui-pack/PNG/Red/Default/button_rectangle_depth_gloss.png")
const KENNEY_ICON_PLAY = preload("res://assets/third_party/kenney/ui-pack/PNG/Extra/Default/icon_play_dark.png")
const KENNEY_ICON_REPEAT = preload("res://assets/third_party/kenney/ui-pack/PNG/Extra/Default/icon_repeat_dark.png")
const BUTTON_TEXT_DARK = Color("2a1b12")
const PANEL_TEXT_DARK = Color("2a1b12")

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
@onready var _settings_layer: Control = $SettingsLayer
@onready var _settings_message_label: Label = $SettingsLayer/PanelContainer/VBoxContainer/MessageLabel
@onready var _settings_music_button: Button = $SettingsLayer/PanelContainer/VBoxContainer/AudioSection/MusicButton
@onready var _settings_sfx_button: Button = $SettingsLayer/PanelContainer/VBoxContainer/AudioSection/SfxButton
@onready var _playtest_section: VBoxContainer = $SettingsLayer/PanelContainer/VBoxContainer/PlaytestSection
@onready var _playtest_level_select: OptionButton = $SettingsLayer/PanelContainer/VBoxContainer/PlaytestSection/LevelSelect
@onready var _playtest_open_button: Button = $SettingsLayer/PanelContainer/VBoxContainer/PlaytestSection/OpenLevelButton
@onready var _settings_cancel_button: Button = $SettingsLayer/PanelContainer/VBoxContainer/ButtonRow/CancelButton
@onready var _settings_reset_button: Button = $SettingsLayer/PanelContainer/VBoxContainer/ButtonRow/ResetButton
@onready var _audio_player: AudioStreamPlayer = $AudioPlayer
@onready var _music_player: AudioStreamPlayer = $MusicPlayer
@onready var _profile_panel: PanelContainer = $MarginContainer/RootColumn/ProfilePanel
@onready var _events_panel: PanelContainer = $MarginContainer/RootColumn/EventsPanel
@onready var _current_level_panel: PanelContainer = $MarginContainer/RootColumn/CurrentLevelPanel
@onready var _economy_panel: PanelContainer = $MarginContainer/RootColumn/EconomyPanel
@onready var _avatar_placeholder: Panel = $MarginContainer/RootColumn/ProfilePanel/HBoxContainer/AvatarPlaceholder

var _level_data: Dictionary = {}
var _progress_payload: Dictionary = {}
var _playtest_payload: Dictionary = {}
var _playtest_level_ids: Array[String] = []
var _status_message: String = "Beta offline-first: avatar, eventos, perfil e configuracoes seguem como placeholder."
var _music_enabled: bool = true
var _sfx_enabled: bool = true


func setup(level_data: Dictionary, progress_payload: Dictionary = {}, playtest_payload: Dictionary = {}) -> void:
    _level_data = level_data.duplicate(true)
    _progress_payload = progress_payload.duplicate(true)
    _playtest_payload = playtest_payload.duplicate(true)
    _music_enabled = bool(_progress_payload.get("music_enabled", true))
    _sfx_enabled = bool(_progress_payload.get("sfx_enabled", true))


func _ready() -> void:
    _apply_visual_theme()
    _apply_audio_preferences()
    _play_music_from_file(MUSIC_HOME_PATH, -18.0)
    _play_button.pressed.connect(_on_play_pressed)
    _profile_button.pressed.connect(_on_profile_pressed)
    _events_button.pressed.connect(_on_events_pressed)
    _shop_button.pressed.connect(_on_shop_pressed)
    _settings_button.pressed.connect(_on_settings_pressed)
    _settings_music_button.pressed.connect(_on_settings_music_pressed)
    _settings_sfx_button.pressed.connect(_on_settings_sfx_pressed)
    _settings_cancel_button.pressed.connect(_on_settings_cancel_pressed)
    _settings_reset_button.pressed.connect(_on_settings_reset_pressed)
    _playtest_open_button.pressed.connect(_on_playtest_open_pressed)
    _hide_settings()
    _configure_playtest_tools()
    _refresh_settings_controls()
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
    _play_sound(SOUND_CLICK_B, 1.0)
    emit_signal("play_requested", String(_level_data.get("id", "level_001")))


func _on_profile_pressed() -> void:
    _play_sound(SOUND_TAP_A, 1.0)
    _status_message = "Perfil permanece como placeholder no beta offline, sem login ou foto."
    _refresh_view()


func _on_events_pressed() -> void:
    _play_sound(SOUND_TAP_A, 1.04)
    _status_message = "Eventos ficam para depois do beta. Por enquanto, o foco e validar a progressao linear."
    _refresh_view()


func _on_shop_pressed() -> void:
    _play_sound(SOUND_CLICK_A, 0.98)
    _status_message = "O shop entra no pos-beta. As moedas ja aparecem no home como placeholder da economia futura."
    _refresh_view()


func _on_settings_pressed() -> void:
    _play_sound(SOUND_SWITCH_A, 1.0)
    _refresh_settings_controls()
    _settings_message_label.text = "Musica e SFX podem ser ligados ou desligados agora e ficam salvos no aparelho. O reset de save tambem apaga esse progresso local e nao pode ser desfeito.\n\nAgradecimentos do beta: pack de gems da pasta Sylly por Andrew Tidey (Gem Match Three, CC0) e UI, fontes, SFX e musicas temporarias da Kenney."
    _settings_layer.visible = true


func _on_settings_cancel_pressed() -> void:
    _play_sound(SOUND_CLICK_A, 0.95)
    _hide_settings()


func _on_settings_reset_pressed() -> void:
    _play_sound(SOUND_CLICK_B, 0.92)
    _hide_settings()
    emit_signal("reset_save_requested")


func _on_settings_music_pressed() -> void:
    _music_enabled = not _music_enabled
    _progress_payload["music_enabled"] = _music_enabled
    _apply_audio_preferences()
    _refresh_settings_controls()
    emit_signal("audio_settings_changed", _music_enabled, _sfx_enabled)
    _play_sound(SOUND_SWITCH_A, 1.0)


func _on_settings_sfx_pressed() -> void:
    var next_sfx_enabled: bool = not _sfx_enabled
    if next_sfx_enabled:
        _sfx_enabled = true
        _play_sound(SOUND_SWITCH_A, 1.0)
    else:
        _sfx_enabled = false

    _progress_payload["sfx_enabled"] = _sfx_enabled
    _refresh_settings_controls()
    emit_signal("audio_settings_changed", _music_enabled, _sfx_enabled)


func _on_playtest_open_pressed() -> void:
    if not _playtest_section.visible:
        return

    var selected_index: int = _playtest_level_select.get_selected_id()
    if selected_index < 0 or selected_index >= _playtest_level_ids.size():
        return

    _play_sound(SOUND_CLICK_B, 1.04)
    _hide_settings()
    emit_signal("playtest_level_requested", _playtest_level_ids[selected_index])


func _hide_settings() -> void:
    if _settings_layer != null:
        _settings_layer.visible = false


func _configure_playtest_tools() -> void:
    var is_enabled: bool = bool(_playtest_payload.get("enabled", false))
    _playtest_section.visible = is_enabled
    if not is_enabled:
        return

    _playtest_level_ids.clear()
    _playtest_level_select.clear()

    var level_ids_variant: Variant = _playtest_payload.get("level_ids", [])
    for level_id in level_ids_variant:
        _playtest_level_ids.append(String(level_id))

    for index in range(_playtest_level_ids.size()):
        _playtest_level_select.add_item(_build_level_id_label(_playtest_level_ids[index]), index)

    var selected_level_id: String = String(_playtest_payload.get("selected_level_id", String(_level_data.get("id", "level_001"))))
    var selected_index: int = _playtest_level_ids.find(selected_level_id)
    if selected_index == -1:
        selected_index = _playtest_level_ids.find("level_010")
    if selected_index == -1 and not _playtest_level_ids.is_empty():
        selected_index = 0

    if selected_index >= 0:
        _playtest_level_select.select(selected_index)


func _refresh_settings_controls() -> void:
    _settings_music_button.text = "Musica: %s" % ("Ligada" if _music_enabled else "Desligada")
    _settings_sfx_button.text = "SFX: %s" % ("Ligado" if _sfx_enabled else "Desligado")


func _apply_audio_preferences() -> void:
    if _music_player == null:
        return

    if not _music_enabled:
        _music_player.stop()
        return

    if _music_player.playing:
        return

    _play_music_from_file(MUSIC_HOME_PATH, -18.0)


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
    _apply_font_style(_title_label, KENNEY_FONT_TITLE)
    _apply_font_style(_subtitle_label, KENNEY_FONT_BODY)
    _apply_font_style($MarginContainer/RootColumn/HeaderRow/TitleColumn/EyebrowLabel, KENNEY_FONT_BODY)
    _apply_font_style(_current_level_label, KENNEY_FONT_BODY)
    _apply_font_style(_highest_unlocked_label, KENNEY_FONT_BODY)
    _apply_font_style(_last_completed_label, KENNEY_FONT_BODY)
    _apply_font_style(_progress_label, KENNEY_FONT_BODY)
    _apply_font_style(_coins_label, KENNEY_FONT_BODY)
    _apply_font_style(_status_label, KENNEY_FONT_BODY)
    _apply_font_style($MarginContainer/RootColumn/ProfilePanel/HBoxContainer/VBoxContainer/ProfileTitleLabel, KENNEY_FONT_TITLE)
    _apply_font_style($MarginContainer/RootColumn/ProfilePanel/HBoxContainer/VBoxContainer/ProfileBodyLabel, KENNEY_FONT_BODY)
    _apply_font_style($MarginContainer/RootColumn/EventsPanel/VBoxContainer/EventsTitleLabel, KENNEY_FONT_TITLE)
    _apply_font_style($MarginContainer/RootColumn/EventsPanel/VBoxContainer/EventsBodyLabel, KENNEY_FONT_BODY)
    _apply_font_style($MarginContainer/RootColumn/CurrentLevelPanel/VBoxContainer/CurrentLevelTitleLabel, KENNEY_FONT_TITLE)
    _apply_font_style($MarginContainer/RootColumn/EconomyPanel/VBoxContainer/EconomyTitleLabel, KENNEY_FONT_TITLE)
    _apply_font_style($MarginContainer/RootColumn/EconomyPanel/VBoxContainer/EconomyBodyLabel, KENNEY_FONT_BODY)
    _title_label.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    _subtitle_label.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    _current_level_label.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    _highest_unlocked_label.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    _last_completed_label.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    _progress_label.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    _coins_label.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    _status_label.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $MarginContainer/RootColumn/ProfilePanel/HBoxContainer/VBoxContainer/ProfileTitleLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $MarginContainer/RootColumn/ProfilePanel/HBoxContainer/VBoxContainer/ProfileBodyLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $MarginContainer/RootColumn/EventsPanel/VBoxContainer/EventsTitleLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $MarginContainer/RootColumn/EventsPanel/VBoxContainer/EventsBodyLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $MarginContainer/RootColumn/CurrentLevelPanel/VBoxContainer/CurrentLevelTitleLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $MarginContainer/RootColumn/EconomyPanel/VBoxContainer/EconomyTitleLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $MarginContainer/RootColumn/EconomyPanel/VBoxContainer/EconomyBodyLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)

    _apply_panel_style(_sun_disc, palette["sun"], palette["sun"], 999)
    _apply_panel_style(_leaf_cluster_left, palette["leaf_primary"], palette["leaf_primary"], 160)
    _apply_panel_style(_leaf_cluster_right, palette["leaf_secondary"], palette["leaf_secondary"], 160)
    _apply_panel_style(_avatar_placeholder, Color("f7c86a"), palette["panel_border"], 40)

    for panel in [_profile_panel, _events_panel, _current_level_panel, _economy_panel]:
        _apply_texture_panel_style(panel)

    _apply_kenney_button_style(_play_button, KENNEY_BUTTON_PRIMARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_profile_button, KENNEY_BUTTON_SECONDARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_events_button, KENNEY_BUTTON_SECONDARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_shop_button, KENNEY_BUTTON_SECONDARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_settings_button, KENNEY_BUTTON_SECONDARY, BUTTON_TEXT_DARK)
    _play_button.icon = KENNEY_ICON_PLAY

    _apply_texture_panel_style($SettingsLayer/PanelContainer)
    _apply_font_style($SettingsLayer/PanelContainer/VBoxContainer/TitleLabel, KENNEY_FONT_TITLE)
    _apply_font_style(_settings_message_label, KENNEY_FONT_BODY)
    _apply_font_style($SettingsLayer/PanelContainer/VBoxContainer/AudioSection/TitleLabel, KENNEY_FONT_TITLE)
    _apply_font_style($SettingsLayer/PanelContainer/VBoxContainer/AudioSection/BodyLabel, KENNEY_FONT_BODY)
    _apply_font_style($SettingsLayer/PanelContainer/VBoxContainer/PlaytestSection/TitleLabel, KENNEY_FONT_TITLE)
    _apply_font_style($SettingsLayer/PanelContainer/VBoxContainer/PlaytestSection/BodyLabel, KENNEY_FONT_BODY)
    _settings_message_label.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $SettingsLayer/PanelContainer/VBoxContainer/AudioSection/TitleLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $SettingsLayer/PanelContainer/VBoxContainer/AudioSection/BodyLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $SettingsLayer/PanelContainer/VBoxContainer/PlaytestSection/TitleLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    $SettingsLayer/PanelContainer/VBoxContainer/PlaytestSection/BodyLabel.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    _playtest_level_select.add_theme_color_override("font_color", PANEL_TEXT_DARK)
    _apply_kenney_button_style(_settings_music_button, KENNEY_BUTTON_SECONDARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_settings_sfx_button, KENNEY_BUTTON_SECONDARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_playtest_open_button, KENNEY_BUTTON_PRIMARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_settings_cancel_button, KENNEY_BUTTON_SECONDARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_settings_reset_button, KENNEY_BUTTON_DANGER, BUTTON_TEXT_DARK)
    _playtest_open_button.icon = KENNEY_ICON_PLAY
    _settings_reset_button.icon = KENNEY_ICON_REPEAT


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


func _apply_texture_panel_style(target: Control) -> void:
    var style := StyleBoxTexture.new()
    style.texture = KENNEY_PANEL_TEXTURE
    style.texture_margin_left = 18
    style.texture_margin_top = 18
    style.texture_margin_right = 18
    style.texture_margin_bottom = 18
    style.draw_center = true
    var theme_key: String = "panel" if target is PanelContainer or target is Panel else "normal"
    target.add_theme_stylebox_override(theme_key, style)


func _apply_kenney_button_style(button: Button, texture: Texture2D, text_color: Color) -> void:
    var normal := StyleBoxTexture.new()
    normal.texture = texture
    normal.texture_margin_left = 24
    normal.texture_margin_top = 20
    normal.texture_margin_right = 24
    normal.texture_margin_bottom = 20
    normal.draw_center = true

    var hover := normal.duplicate()

    var pressed := normal.duplicate()
    pressed.expand_margin_top = 2

    button.add_theme_stylebox_override("normal", normal)
    button.add_theme_stylebox_override("hover", hover)
    button.add_theme_stylebox_override("pressed", pressed)
    button.add_theme_color_override("font_color", text_color)
    button.add_theme_color_override("font_hover_color", text_color)
    button.add_theme_color_override("font_pressed_color", text_color)
    button.add_theme_constant_override("h_separation", 12)
    button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
    button.expand_icon = true
    _apply_font_style(button, KENNEY_FONT_BODY)


func _apply_font_style(target: Control, font_resource: FontFile) -> void:
    if target == null or font_resource == null:
        return

    target.add_theme_font_override("font", font_resource)


func _play_sound(stream: AudioStream, pitch_scale: float = 1.0) -> void:
    if not _sfx_enabled or _audio_player == null or stream == null:
        return

    _audio_player.stop()
    _audio_player.stream = stream
    _audio_player.pitch_scale = pitch_scale
    _audio_player.play()


func _play_music(stream: AudioStream, volume_db: float) -> void:
    if _music_player == null:
        return

    if not _music_enabled or stream == null:
        _music_player.stop()
        return

    var music_stream: AudioStream = stream.duplicate(true)
    if music_stream is AudioStreamOggVorbis:
        music_stream.loop = true

    _music_player.stop()
    _music_player.stream = music_stream
    _music_player.volume_db = volume_db
    _music_player.play()


func _play_music_from_file(resource_path: String, volume_db: float) -> void:
    var music_stream: AudioStream = _load_music_stream(resource_path)
    if music_stream == null:
        return

    _play_music(music_stream, volume_db)


func _load_music_stream(resource_path: String) -> AudioStream:
    var imported_stream: Resource = ResourceLoader.load(resource_path)
    if imported_stream is AudioStream:
        return imported_stream

    if not FileAccess.file_exists(resource_path):
        return null

    var extension: String = resource_path.get_extension().to_lower()
    if extension == "ogg":
        return AudioStreamOggVorbis.load_from_file(ProjectSettings.globalize_path(resource_path))
    if extension == "wav":
        return AudioStreamWAV.load_from_file(ProjectSettings.globalize_path(resource_path))

    return null
