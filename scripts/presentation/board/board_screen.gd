extends Control
class_name BoardScreen

signal home_requested

const SOUND_CLICK_A = preload("res://assets/third_party/kenney/ui-pack/Sounds/click-a.ogg")
const SOUND_CLICK_B = preload("res://assets/third_party/kenney/ui-pack/Sounds/click-b.ogg")
const SOUND_SWITCH_A = preload("res://assets/third_party/kenney/ui-pack/Sounds/switch-a.ogg")
const SOUND_SWITCH_B = preload("res://assets/third_party/kenney/ui-pack/Sounds/switch-b.ogg")
const SOUND_TAP_A = preload("res://assets/third_party/kenney/ui-pack/Sounds/tap-a.ogg")
const SOUND_TAP_B = preload("res://assets/third_party/kenney/ui-pack/Sounds/tap-b.ogg")
const MUSIC_BOARD_PATH = "res://assets/third_party/kenney/music-jingles/jingles_STEEL07.ogg"

const ApplySwapUseCaseScript = preload("res://scripts/application/use_cases/apply_swap_use_case.gd")
const BoardGeneratorScript = preload("res://scripts/domain/board/services/board_generator.gd")
const BoardCellScript = preload("res://scripts/domain/board/models/board_cell.gd")
const BoardPieceScript = preload("res://scripts/domain/board/models/board_piece.gd")
const GravityResolverScript = preload("res://scripts/domain/board/services/gravity_resolver.gd")
const LevelProgressUseCaseScript = preload("res://scripts/application/use_cases/level_progress_use_case.gd")
const LevelRepositoryScript = preload("res://scripts/infrastructure/levels/level_repository.gd")
const LocalSaveGatewayScript = preload("res://scripts/infrastructure/persistence/local_save_gateway.gd")
const MatchFinderScript = preload("res://scripts/domain/board/services/match_finder.gd")
const ObstacleResolverScript = preload("res://scripts/domain/board/services/obstacle_resolver.gd")
const PossibleMoveFinderScript = preload("res://scripts/domain/board/services/possible_move_finder.gd")
const SpecialPieceResolverScript = preload("res://scripts/domain/board/services/special_piece_resolver.gd")
const StartLevelUseCaseScript = preload("res://scripts/application/use_cases/start_level_use_case.gd")

@onready var _background: ColorRect = $Background
@onready var _glow_orb: Panel = $GlowOrb
@onready var _leaf_glow_left: Panel = $LeafGlowLeft
@onready var _leaf_glow_right: Panel = $LeafGlowRight
@onready var _title_label: Label = $MarginContainer/RootColumn/TitleLabel
@onready var _moves_label: Label = $MarginContainer/RootColumn/HudRow/MovesLabel
@onready var _goal_label: Label = $MarginContainer/RootColumn/HudRow/GoalLabel
@onready var _pause_button: Button = $MarginContainer/RootColumn/HudRow/PauseButton
@onready var _status_label: Label = $MarginContainer/RootColumn/StatusLabel
@onready var _board_shell: PanelContainer = $MarginContainer/RootColumn/BoardShell
@onready var _board_grid: GridContainer = $MarginContainer/RootColumn/BoardShell/MarginContainer/BoardGrid
@onready var _combo_feedback_label: Label = $MarginContainer/RootColumn/ComboFeedbackLabel
@onready var _audio_player: AudioStreamPlayer = $AudioPlayer
@onready var _music_player: AudioStreamPlayer = $MusicPlayer
@onready var _pause_layer: Control = $PauseLayer
@onready var _pause_panel: PanelContainer = $PauseLayer/PanelContainer
@onready var _pause_title_label: Label = $PauseLayer/PanelContainer/VBoxContainer/TitleLabel
@onready var _pause_message_label: Label = $PauseLayer/PanelContainer/VBoxContainer/MessageLabel
@onready var _pause_resume_button: Button = $PauseLayer/PanelContainer/VBoxContainer/ButtonRow/ResumeButton
@onready var _pause_home_button: Button = $PauseLayer/PanelContainer/VBoxContainer/ButtonRow/HomeButton
@onready var _end_state_layer: Control = $EndStateLayer
@onready var _end_state_title_label: Label = $EndStateLayer/PanelContainer/VBoxContainer/TitleLabel
@onready var _end_state_message_label: Label = $EndStateLayer/PanelContainer/VBoxContainer/MessageLabel
@onready var _end_state_panel: PanelContainer = $EndStateLayer/PanelContainer
@onready var _restart_button: Button = $EndStateLayer/PanelContainer/VBoxContainer/ButtonRow/RestartButton
@onready var _next_button: Button = $EndStateLayer/PanelContainer/VBoxContainer/ButtonRow/NextButton

var _session_state: LevelSessionState
var _level_data: Dictionary = {}
var _selected_position: Vector2i = Vector2i(-1, -1)
var _status_message: String = "Carregando tabuleiro..."
var _board_generator
var _apply_swap_use_case
var _level_repository
var _start_level_use_case
var _save_gateway
var _level_progress_use_case
var _has_recorded_victory: bool = false
var _has_requested_home: bool = false
var _has_played_end_state_sound: bool = false
var _is_paused: bool = false
var _combo_feedback_base_position: Vector2 = Vector2.ZERO


func setup(level_data: Dictionary, session_state: LevelSessionState) -> void:
    _level_data = level_data
    _session_state = session_state
    _selected_position = Vector2i(-1, -1)
    _status_message = "Selecione duas pecas vizinhas para formar combinacoes."
    _has_recorded_victory = false
    _has_requested_home = false
    _has_played_end_state_sound = false
    _is_paused = false
    _hide_end_state()
    _hide_pause_layer()
    if is_node_ready():
        _apply_level_theme()


func _ready() -> void:
    _initialize_services()
    _restart_button.pressed.connect(_on_restart_pressed)
    _next_button.pressed.connect(_on_next_pressed)
    _pause_button.pressed.connect(_on_pause_pressed)
    _pause_resume_button.pressed.connect(_on_pause_resume_pressed)
    _pause_home_button.pressed.connect(_on_pause_home_pressed)
    _combo_feedback_base_position = _combo_feedback_label.position
    _combo_feedback_label.modulate.a = 0.0
    _hide_pause_layer()
    _play_music_from_file(MUSIC_BOARD_PATH, -20.0)
    _apply_level_theme()
    _refresh_view()


func _initialize_services() -> void:
    if _board_generator == null:
        _board_generator = BoardGeneratorScript.new()

    if _level_repository == null:
        _level_repository = LevelRepositoryScript.new()

    if _start_level_use_case == null:
        _start_level_use_case = StartLevelUseCaseScript.new(_level_repository, _board_generator)

    if _save_gateway == null:
        _save_gateway = LocalSaveGatewayScript.new()

    if _level_progress_use_case == null:
        _level_progress_use_case = LevelProgressUseCaseScript.new(_save_gateway)

    if _apply_swap_use_case == null:
        var match_finder = MatchFinderScript.new()
        _apply_swap_use_case = ApplySwapUseCaseScript.new()
        _apply_swap_use_case.configure(
            match_finder,
            GravityResolverScript.new(),
            ObstacleResolverScript.new(),
            PossibleMoveFinderScript.new(match_finder),
            _board_generator,
            SpecialPieceResolverScript.new()
        )


func _refresh_view() -> void:
    if _session_state == null:
        _title_label.text = "Aldeia das Cores"
        _moves_label.text = "Jogadas: -"
        _goal_label.text = "Objetivo: -"
        _status_label.text = "Nenhum tabuleiro carregado."
        _pause_button.disabled = true
        return

    _title_label.text = String(_level_data.get("name", "Aldeia das Cores"))
    _moves_label.text = "Jogadas: %s" % _session_state.moves_remaining
    _goal_label.text = _build_goal_text()
    _status_label.text = _status_message
    _pause_button.disabled = _session_state.status != "playing" or _is_paused
    _render_grid()
    _refresh_end_state()


func _render_grid() -> void:
    for child in _board_grid.get_children():
        child.queue_free()

    _board_grid.columns = _session_state.board_state.width

    for row in range(_session_state.board_state.height):
        for column in range(_session_state.board_state.width):
            if _session_state.board_state.can_hold_piece(row, column):
                _board_grid.add_child(_build_piece_button(row, column))
            elif _session_state.board_state.has_cell(row, column):
                _board_grid.add_child(_build_obstacle_cell(row, column))
            else:
                _board_grid.add_child(_build_blocked_cell())


func _build_piece_button(row: int, column: int) -> Button:
    var button: Button = Button.new()
    var piece = _session_state.board_state.get_piece(row, column)
    var cell: BoardCell = _session_state.board_state.get_cell(row, column)
    var is_selected: bool = _selected_position == Vector2i(column, row)
    var style: StyleBoxFlat = StyleBoxFlat.new()

    button.custom_minimum_size = Vector2(112, 112)
    button.focus_mode = Control.FOCUS_NONE
    button.disabled = _is_paused or not _session_state.can_accept_input()
    button.mouse_filter = Control.MOUSE_FILTER_STOP
    button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    button.text = _piece_label(piece, cell, is_selected)

    style.bg_color = _piece_color(piece)
    style.corner_radius_top_left = 16
    style.corner_radius_top_right = 16
    style.corner_radius_bottom_right = 16
    style.corner_radius_bottom_left = 16
    style.border_width_left = 4
    style.border_width_top = 4
    style.border_width_right = 4
    style.border_width_bottom = 4
    if is_selected:
        style.border_color = Color(1, 1, 1, 0.95)
    elif cell != null and cell.has_obstacle():
        style.border_color = _overlay_border_color(cell)
        style.bg_color = style.bg_color.lerp(_overlay_tint_color(cell), 0.35)
    else:
        style.border_color = Color(0.08, 0.16, 0.12, 0.5)

    button.add_theme_stylebox_override("normal", style)
    button.add_theme_stylebox_override("hover", style)
    button.add_theme_stylebox_override("pressed", style)
    button.add_theme_font_size_override("font_size", 18 if cell != null and cell.has_obstacle() else 22)
    button.gui_input.connect(_on_piece_gui_input.bind(Vector2i(column, row)))

    return button


func _build_blocked_cell() -> Control:
    var panel: Panel = Panel.new()
    var style: StyleBoxFlat = StyleBoxFlat.new()

    panel.custom_minimum_size = Vector2(112, 112)
    style.bg_color = Color(0.09, 0.16, 0.12, 0.45)
    style.corner_radius_top_left = 16
    style.corner_radius_top_right = 16
    style.corner_radius_bottom_right = 16
    style.corner_radius_bottom_left = 16
    panel.add_theme_stylebox_override("panel", style)

    return panel


func _build_obstacle_cell(row: int, column: int) -> Control:
    var button: Button = Button.new()
    var cell: BoardCell = _session_state.board_state.get_cell(row, column)
    var style: StyleBoxFlat = StyleBoxFlat.new()

    button.custom_minimum_size = Vector2(112, 112)
    button.focus_mode = Control.FOCUS_NONE
    button.disabled = true
    button.mouse_filter = Control.MOUSE_FILTER_STOP
    button.text = _obstacle_label(cell)

    style.bg_color = _obstacle_color(cell)
    style.corner_radius_top_left = 16
    style.corner_radius_top_right = 16
    style.corner_radius_bottom_right = 16
    style.corner_radius_bottom_left = 16
    style.border_width_left = 4
    style.border_width_top = 4
    style.border_width_right = 4
    style.border_width_bottom = 4
    style.border_color = Color(0.33, 0.18, 0.06, 0.9)

    button.add_theme_stylebox_override("normal", style)
    button.add_theme_stylebox_override("disabled", style)
    button.add_theme_font_size_override("font_size", 20)

    return button


func _on_piece_pressed(position: Vector2i) -> void:
    if _is_paused or not _session_state.can_accept_input():
        return

    if _selected_position == Vector2i(-1, -1):
        _play_sound(SOUND_TAP_A, 1.0)
        _selected_position = position
        _status_message = "Peca selecionada. Escolha uma gema vizinha."
        _refresh_view()
        return

    if position == _selected_position:
        _play_sound(SOUND_TAP_B, 0.98)
        _selected_position = Vector2i(-1, -1)
        _status_message = "Selecao cancelada."
        _refresh_view()
        return

    if not _is_adjacent(_selected_position, position):
        _play_sound(SOUND_TAP_A, 1.04)
        _selected_position = position
        _status_message = "Selecione uma segunda gema vizinha."
        _refresh_view()
        return

    var result: Dictionary = _apply_swap_use_case.execute(_session_state, _selected_position, position)
    _selected_position = Vector2i(-1, -1)
    _status_message = String(result.get("message", "Jogada processada."))
    _play_resolution_sound(result)
    _show_combo_feedback(result)
    _refresh_view()


func _on_piece_gui_input(event: InputEvent, position: Vector2i) -> void:
    if event is InputEventMouseButton:
        var mouse_event := event as InputEventMouseButton
        if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
            _on_piece_pressed(position)


func _piece_color(piece) -> Color:
    if piece == null:
        return Color(0.18, 0.18, 0.18)

    match piece.color_id:
        "yellow":
            return Color("f7c948")
        "red":
            return Color("f25f5c")
        "blue":
            return Color("4ea8de")
        "green":
            return Color("9cd85a")
        _:
            return Color("d9d9d9")


func _piece_label(piece, cell: BoardCell, is_selected: bool) -> String:
    if piece == null:
        return ""

    var prefix: String = "> " if is_selected else ""
    var symbol: String = piece.color_id.substr(0, 1).to_upper()

    if piece.special_type == BoardPieceScript.SPECIAL_MISSILE_HORIZONTAL:
        symbol = "H"
    elif piece.special_type == BoardPieceScript.SPECIAL_MISSILE_VERTICAL:
        symbol = "V"
    elif piece.special_type == BoardPieceScript.SPECIAL_RAINBOW:
        symbol = "*"

    if cell != null and cell.has_obstacle():
        symbol = "%s %s" % [_overlay_label(cell), symbol]

    return "%s%s" % [prefix, symbol]


func _overlay_label(cell: BoardCell) -> String:
    if cell.obstacle_type == BoardCellScript.OBSTACLE_ICE:
        return "GE"

    if cell.obstacle_type == BoardCellScript.OBSTACLE_GRASS:
        return "GR"

    if cell.obstacle_type == BoardCellScript.OBSTACLE_DENSE_GRASS:
        return "G%s" % cell.obstacle_hits_remaining

    return "OB"


func _overlay_border_color(cell: BoardCell) -> Color:
    if cell.obstacle_type == BoardCellScript.OBSTACLE_ICE:
        return Color("8bd3ff")

    if cell.obstacle_type == BoardCellScript.OBSTACLE_GRASS:
        return Color("72c24d")

    if cell.obstacle_type == BoardCellScript.OBSTACLE_DENSE_GRASS:
        return Color("2f9e44")

    return Color(0.08, 0.16, 0.12, 0.5)


func _overlay_tint_color(cell: BoardCell) -> Color:
    if cell.obstacle_type == BoardCellScript.OBSTACLE_ICE:
        return Color("dff4ff")

    if cell.obstacle_type == BoardCellScript.OBSTACLE_GRASS:
        return Color("d7f7c2")

    if cell.obstacle_type == BoardCellScript.OBSTACLE_DENSE_GRASS:
        return Color("b7ef8a")

    return Color(1, 1, 1, 1)


func _is_adjacent(first_position: Vector2i, second_position: Vector2i) -> bool:
    var distance: int = absi(first_position.x - second_position.x) + absi(first_position.y - second_position.y)
    return distance == 1


func _build_goal_text() -> String:
    if _session_state.goals.is_empty():
        return "Objetivo: livre"

    var parts: Array[String] = []

    for goal in _session_state.goals:
        if goal.get("type", "") == "collect_color":
            parts.append(
                "%s %s/%s" % [
                    String(goal.get("color", "")).capitalize(),
                    int(goal.get("current_amount", 0)),
                    int(goal.get("target_amount", 0))
                ]
            )
        elif goal.get("type", "") == "break_obstacle":
            parts.append(
                "%s %s/%s" % [
                    _obstacle_goal_name(String(goal.get("obstacle_type", ""))),
                    int(goal.get("current_amount", 0)),
                    int(goal.get("target_amount", 0))
                ]
            )

    return "Objetivo: %s" % ", ".join(parts)


func _obstacle_goal_name(obstacle_type: String) -> String:
    if obstacle_type == BoardCellScript.OBSTACLE_BOX:
        return "Caixas"

    if obstacle_type == BoardCellScript.OBSTACLE_ICE:
        return "Gelo"

    if obstacle_type == BoardCellScript.OBSTACLE_GRASS:
        return "Grama"

    if obstacle_type == BoardCellScript.OBSTACLE_DENSE_GRASS:
        return "Grama densa"

    return "Obstaculos"


func _obstacle_label(cell: BoardCell) -> String:
    if cell == null:
        return ""

    if cell.obstacle_type == BoardCellScript.OBSTACLE_BOX:
        return "CX"

    return "X"


func _obstacle_color(cell: BoardCell) -> Color:
    if cell == null:
        return Color(0.24, 0.18, 0.11)

    if cell.obstacle_type == BoardCellScript.OBSTACLE_BOX:
        return Color("a86a3a")

    return Color(0.24, 0.18, 0.11)


func _refresh_end_state() -> void:
    if _session_state == null:
        _hide_end_state()
        return

    if _session_state.status == "victory":
        _handle_victory()
        return

    if _session_state.status == "defeat":
        _play_end_state_sound(false)
        _show_end_state("Fase perdida", "As jogadas acabaram. Voltando ao home.", true, false, "Voltar agora")
        _request_home_return()
        return

    _hide_end_state()


func _handle_victory() -> void:
    var next_level_id: String = _find_next_level_id(_session_state.level_id)
    if not _has_recorded_victory:
        _level_progress_use_case.record_victory(_session_state.level_id, next_level_id)
        _has_recorded_victory = true

    var message: String = "Objetivos concluidos. Progresso salvo localmente."
    if next_level_id != "":
        message += " A proxima fase ja foi desbloqueada no home."
    else:
        message += " Voce concluiu o pacote tecnico atual."

    message += " Voltando ao home."
    _play_end_state_sound(true)
    _show_end_state("Fase vencida", message, true, false, "Voltar agora")
    _request_home_return()


func _show_end_state(title: String, message: String, show_restart: bool, show_next: bool, restart_button_text: String = "Reiniciar") -> void:
    _end_state_title_label.text = title
    _end_state_message_label.text = message
    _restart_button.text = restart_button_text
    _restart_button.visible = show_restart
    _restart_button.disabled = not show_restart
    _next_button.visible = show_next
    _next_button.disabled = not show_next
    _end_state_layer.visible = true


func _hide_end_state() -> void:
    if _end_state_layer != null:
        _end_state_layer.visible = false


func _on_restart_pressed() -> void:
    if _end_state_layer.visible and _session_state != null and _session_state.status != "playing":
        _play_sound(SOUND_CLICK_B, 1.0)
        _emit_home_requested()
        return

    _play_sound(SOUND_SWITCH_A, 1.0)
    _load_level(String(_level_data.get("id", "level_001")))


func _on_next_pressed() -> void:
    var next_level_id: String = _find_next_level_id(String(_level_data.get("id", "")))
    if next_level_id != "":
        _load_level(next_level_id)


func _on_pause_pressed() -> void:
    if _session_state == null or _session_state.status != "playing":
        return

    _play_sound(SOUND_SWITCH_A, 1.0)
    _is_paused = true
    _pause_message_label.text = "O jogo esta pausado. Voce pode continuar ou voltar ao home."
    _pause_layer.visible = true
    _refresh_view()


func _on_pause_resume_pressed() -> void:
    _play_sound(SOUND_CLICK_A, 1.0)
    _is_paused = false
    _hide_pause_layer()
    _refresh_view()


func _on_pause_home_pressed() -> void:
    _play_sound(SOUND_CLICK_B, 1.0)
    _hide_pause_layer()
    _emit_home_requested()


func _hide_pause_layer() -> void:
    if _pause_layer != null:
        _pause_layer.visible = false


func _load_level(level_id: String) -> void:
    var payload: Dictionary = _start_level_use_case.execute(level_id)
    if payload.is_empty():
        _status_message = "Falha ao carregar a fase %s." % level_id
        _refresh_view()
        return

    _level_progress_use_case.record_opened_level(level_id)
    setup(payload["level_data"], payload["session_state"])
    _refresh_view()


func _request_home_return() -> void:
    if _has_requested_home:
        return

    _has_requested_home = true
    var timer := get_tree().create_timer(1.2)
    timer.timeout.connect(_emit_home_requested)


func _emit_home_requested() -> void:
    if not is_inside_tree():
        return

    emit_signal("home_requested")


func _play_resolution_sound(result: Dictionary) -> void:
    if bool(result.get("accepted", false)):
        var cascade_count: int = int(result.get("cascade_count", 1))
        var pitch_scale: float = min(1.18, 1.0 + (0.03 * max(0, cascade_count - 1)))
        _play_sound(SOUND_SWITCH_B, pitch_scale)
        return

    _play_sound(SOUND_SWITCH_A, 0.92)


func _play_end_state_sound(is_victory: bool) -> void:
    if _has_played_end_state_sound:
        return

    _has_played_end_state_sound = true
    if is_victory:
        _play_sound(SOUND_CLICK_B, 1.12)
        return

    _play_sound(SOUND_CLICK_A, 0.82)


func _play_sound(stream: AudioStream, pitch_scale: float = 1.0) -> void:
    if _audio_player == null or stream == null:
        return

    _audio_player.stop()
    _audio_player.stream = stream
    _audio_player.pitch_scale = pitch_scale
    _audio_player.play()


func _play_music(stream: AudioStream, volume_db: float) -> void:
    if _music_player == null or stream == null:
        return

    var music_stream: AudioStream = stream.duplicate(true)
    if music_stream is AudioStreamOggVorbis:
        music_stream.loop = true

    _music_player.stop()
    _music_player.stream = music_stream
    _music_player.volume_db = volume_db
    _music_player.play()


func _play_music_from_file(resource_path: String, volume_db: float) -> void:
    if not FileAccess.file_exists(resource_path):
        return

    var music_stream := AudioStreamOggVorbis.load_from_file(ProjectSettings.globalize_path(resource_path))
    if music_stream == null:
        return

    _play_music(music_stream, volume_db)


func _show_combo_feedback(result: Dictionary) -> void:
    if not bool(result.get("accepted", false)):
        return

    var cascade_count: int = int(result.get("cascade_count", 1))
    var removed_count: int = int(result.get("removed_count", 0))
    var message: String = ""

    if cascade_count >= 3:
        message = "Combo x%s" % cascade_count
    elif cascade_count == 2:
        message = "Cascata x2"
    elif removed_count >= 8:
        message = "Boa jogada!"

    if message == "":
        return

    _combo_feedback_label.text = message
    _combo_feedback_label.position = _combo_feedback_base_position
    _combo_feedback_label.modulate = Color(1, 1, 1, 0)
    _combo_feedback_label.scale = Vector2(0.92, 0.92)

    var tween := create_tween()
    tween.set_parallel(true)
    tween.tween_property(_combo_feedback_label, "modulate:a", 1.0, 0.12)
    tween.tween_property(_combo_feedback_label, "scale", Vector2(1, 1), 0.16)
    tween.chain().tween_interval(0.55)
    tween.chain().set_parallel(true)
    tween.tween_property(_combo_feedback_label, "modulate:a", 0.0, 0.28)
    tween.tween_property(_combo_feedback_label, "position:y", _combo_feedback_base_position.y - 12.0, 0.28)


func _apply_level_theme() -> void:
    if not is_node_ready():
        return

    var palette: Dictionary = _build_theme_palette(String(_level_data.get("theme_id", "mata_clara")))
    _background.color = palette["background"]
    _title_label.add_theme_color_override("font_color", palette["title"])
    _moves_label.add_theme_color_override("font_color", palette["hud"])
    _goal_label.add_theme_color_override("font_color", palette["hud"])
    _status_label.add_theme_color_override("font_color", palette["body"])
    _combo_feedback_label.add_theme_color_override("font_color", palette["title"])
    _pause_title_label.add_theme_color_override("font_color", palette["title"])
    _pause_message_label.add_theme_color_override("font_color", palette["body"])
    _end_state_title_label.add_theme_color_override("font_color", palette["title"])
    _end_state_message_label.add_theme_color_override("font_color", palette["body"])

    _apply_panel_style(_glow_orb, palette["glow"], palette["glow"], 999)
    _apply_panel_style(_leaf_glow_left, palette["leaf_primary"], palette["leaf_primary"], 180)
    _apply_panel_style(_leaf_glow_right, palette["leaf_secondary"], palette["leaf_secondary"], 180)
    _apply_panel_style(_board_shell, palette["board_panel"], palette["board_border"], 34)
    _apply_panel_style(_pause_panel, palette["overlay_panel"], palette["board_border"], 30)
    _apply_panel_style(_end_state_panel, palette["overlay_panel"], palette["board_border"], 30)
    _apply_button_style(_pause_button, palette["button"], palette["button_hover"], palette["button_pressed"], Color("fff8ef"))
    _apply_button_style(_pause_resume_button, palette["button"], palette["button_hover"], palette["button_pressed"], Color("fff8ef"))
    _apply_button_style(_pause_home_button, Color("7b684f"), Color("8d785d"), Color("5f503d"), Color("fff8ef"))
    _apply_button_style(_restart_button, palette["button"], palette["button_hover"], palette["button_pressed"], Color("fff8ef"))
    _apply_button_style(_next_button, palette["button"], palette["button_hover"], palette["button_pressed"], Color("fff8ef"))


func _build_theme_palette(theme_id: String) -> Dictionary:
    match theme_id:
        "rio_claro":
            return {
                "background": Color("cdeffd"),
                "glow": Color("fef6b4"),
                "leaf_primary": Color("57a6c7"),
                "leaf_secondary": Color("2f6f8f"),
                "board_panel": Color(1, 1, 1, 0.84),
                "board_border": Color("2f6f8f"),
                "overlay_panel": Color("f5fbff"),
                "title": Color("1f4960"),
                "hud": Color("245a73"),
                "body": Color("315f75"),
                "button": Color("2f89a8"),
                "button_hover": Color("40a0c1"),
                "button_pressed": Color("246d85")
            }
        "terra_quente":
            return {
                "background": Color("f4d2b2"),
                "glow": Color("ffd48b"),
                "leaf_primary": Color("bf6d43"),
                "leaf_secondary": Color("7d4021"),
                "board_panel": Color(1, 0.97, 0.93, 0.88),
                "board_border": Color("8f4c2c"),
                "overlay_panel": Color("fff7ef"),
                "title": Color("5a2f1a"),
                "hud": Color("6b3d25"),
                "body": Color("79513a"),
                "button": Color("bf5b32"),
                "button_hover": Color("d56f45"),
                "button_pressed": Color("994624")
            }
        "festa_noite":
            return {
                "background": Color("1c2048"),
                "glow": Color("ffd166"),
                "leaf_primary": Color("8844aa"),
                "leaf_secondary": Color("2a8e8a"),
                "board_panel": Color(0.13, 0.16, 0.29, 0.9),
                "board_border": Color("ffd166"),
                "overlay_panel": Color("24294f"),
                "title": Color("fff0c2"),
                "hud": Color("f7d98f"),
                "body": Color("d0d7ff"),
                "button": Color("ff7f50"),
                "button_hover": Color("ff9469"),
                "button_pressed": Color("d7643f")
            }
        _:
            return {
                "background": Color("dff1d0"),
                "glow": Color("ffe88f"),
                "leaf_primary": Color("67a55b"),
                "leaf_secondary": Color("2f6b3e"),
                "board_panel": Color(1, 1, 1, 0.84),
                "board_border": Color("4c7c4b"),
                "overlay_panel": Color("f8fff3"),
                "title": Color("284728"),
                "hud": Color("2f5a33"),
                "body": Color("46604b"),
                "button": Color("cc6a3b"),
                "button_hover": Color("de7d4e"),
                "button_pressed": Color("a6522d")
            }


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
    normal.corner_radius_top_left = 22
    normal.corner_radius_top_right = 22
    normal.corner_radius_bottom_right = 22
    normal.corner_radius_bottom_left = 22

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


func _find_next_level_id(level_id: String) -> String:
    if not level_id.begins_with("level_"):
        return ""

    var numeric_part: String = level_id.trim_prefix("level_")
    if not numeric_part.is_valid_int():
        return ""

    var next_level_id: String = "level_%03d" % [int(numeric_part) + 1]
    var next_level_data: Dictionary = _level_repository.fetch_by_id(next_level_id)
    return next_level_id if not next_level_data.is_empty() else ""
