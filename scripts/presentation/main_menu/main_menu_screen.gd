extends Control
class_name MainMenuScreen

signal play_requested(level_id: String)

@onready var _current_level_label: Label = $MarginContainer/RootColumn/CurrentLevelPanel/VBoxContainer/CurrentLevelLabel
@onready var _progress_label: Label = $MarginContainer/RootColumn/CurrentLevelPanel/VBoxContainer/ProgressLabel
@onready var _coins_label: Label = $MarginContainer/RootColumn/EconomyPanel/VBoxContainer/CoinsLabel
@onready var _status_label: Label = $MarginContainer/RootColumn/StatusLabel
@onready var _play_button: Button = $MarginContainer/RootColumn/PlayButton
@onready var _profile_button: Button = $MarginContainer/RootColumn/ProfilePanel/HBoxContainer/VBoxContainer/ProfileButton
@onready var _events_button: Button = $MarginContainer/RootColumn/EventsPanel/VBoxContainer/EventsButton
@onready var _shop_button: Button = $MarginContainer/RootColumn/EconomyPanel/VBoxContainer/ShopButton
@onready var _settings_button: Button = $MarginContainer/RootColumn/HeaderRow/SettingsButton

var _level_data: Dictionary = {}
var _progress_payload: Dictionary = {}
var _status_message: String = "Beta offline-first: avatar, eventos, perfil e configuracoes seguem como placeholder."


func setup(level_data: Dictionary, progress_payload: Dictionary = {}) -> void:
    _level_data = level_data.duplicate(true)
    _progress_payload = progress_payload.duplicate(true)


func _ready() -> void:
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

    _current_level_label.text = "Fase atual: %s" % _build_level_title(level_id, level_name)
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
