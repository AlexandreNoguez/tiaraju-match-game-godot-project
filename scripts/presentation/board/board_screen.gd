extends Control
class_name BoardScreen

signal home_requested

const BOARD_CELL_SIZE := Vector2(112, 112)
const BOARD_CELL_SPACING := 10.0
const DROP_ANIMATION_MAX_DURATION := 0.80
const DROP_ANIMATION_MIN_DURATION := 0.50
const SWAP_ANIMATION_DURATION := 0.16
const CASCADE_STEP_PAUSE := 0.06
const POP_ANIMATION_GROW_DURATION := 0.08
const POP_ANIMATION_SHRINK_DURATION := 0.12
const SOUND_CLICK_A = preload("res://assets/third_party/kenney/ui-pack/Sounds/click-a.ogg")
const SOUND_CLICK_B = preload("res://assets/third_party/kenney/ui-pack/Sounds/click-b.ogg")
const SOUND_SWITCH_A = preload("res://assets/third_party/kenney/ui-pack/Sounds/switch-a.ogg")
const SOUND_SWITCH_B = preload("res://assets/third_party/kenney/ui-pack/Sounds/switch-b.ogg")
const SOUND_TAP_A = preload("res://assets/third_party/kenney/ui-pack/Sounds/tap-a.ogg")
const SOUND_TAP_B = preload("res://assets/third_party/kenney/ui-pack/Sounds/tap-b.ogg")
const KENNEY_FONT_TITLE = preload("res://assets/third_party/kenney/ui-pack/Font/Kenney Future.ttf")
const KENNEY_FONT_BODY = preload("res://assets/third_party/kenney/ui-pack/Font/Kenney Future Narrow.ttf")
const KENNEY_PANEL_TEXTURE = preload("res://assets/third_party/kenney/ui-pack/PNG/Extra/Default/input_outline_rectangle.png")
const KENNEY_BUTTON_PRIMARY = preload("res://assets/third_party/kenney/ui-pack/PNG/Blue/Default/button_rectangle_depth_gloss.png")
const KENNEY_BUTTON_SECONDARY = preload("res://assets/third_party/kenney/ui-pack/PNG/Yellow/Default/button_rectangle_depth_gloss.png")
const KENNEY_BUTTON_DANGER = preload("res://assets/third_party/kenney/ui-pack/PNG/Red/Default/button_rectangle_depth_gloss.png")
const KENNEY_ICON_PLAY = preload("res://assets/third_party/kenney/ui-pack/PNG/Extra/Default/icon_play_dark.png")
const KENNEY_ICON_REPEAT = preload("res://assets/third_party/kenney/ui-pack/PNG/Extra/Default/icon_repeat_dark.png")
const KENNEY_ICON_ARROW_LEFT = preload("res://assets/third_party/kenney/ui-pack/PNG/Blue/Default/arrow_basic_w.png")
const BUTTON_TEXT_DARK = Color("2a1b12")
const GEM_YELLOW = preload("res://assets/third_party/Sylly/PNG/Medium/Gem Type1 Yellow.png")
const GEM_RED = preload("res://assets/third_party/Sylly/PNG/Medium/Gem Type2 Red.png")
const GEM_GREEN = preload("res://assets/third_party/Sylly/PNG/Medium/Gem Type3 Green.png")
const GEM_BLUE = preload("res://assets/third_party/Sylly/PNG/Medium/Gem Type4 Blue.png")
const SPECIAL_BADGE_FOUR_HORIZONTAL = preload("res://assets/third_party/kenney/ui-pack/PNG/Blue/Default/arrow_basic_e_small.png")
const SPECIAL_BADGE_FOUR_VERTICAL = preload("res://assets/third_party/kenney/ui-pack/PNG/Blue/Default/arrow_basic_n_small.png")
const SPECIAL_BADGE_FIVE = preload("res://assets/third_party/kenney/ui-pack/PNG/Yellow/Default/star.png")
const OBSTACLE_BADGE_BOX = preload("res://assets/third_party/kenney/ui-pack/PNG/Grey/Default/icon_square.png")
const OBSTACLE_BADGE_ICE = preload("res://assets/third_party/kenney/ui-pack/PNG/Blue/Default/icon_circle.png")
const OBSTACLE_BADGE_GRASS = preload("res://assets/third_party/kenney/ui-pack/PNG/Green/Default/icon_checkmark.png")
const OBSTACLE_BADGE_DENSE_GRASS = preload("res://assets/third_party/kenney/ui-pack/PNG/Red/Default/icon_cross.png")
const MUSIC_BOARD_PATHS := [
    "res://assets/third_party/kenney/music-jingles/fase-1.ogg",
    "res://assets/third_party/kenney/music-jingles/fase-2.ogg"
]

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
@onready var _coins_feedback_label: Label = $MarginContainer/RootColumn/CoinsFeedbackLabel
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
var _has_played_end_state_sound: bool = false
var _is_paused: bool = false
var _combo_feedback_base_position: Vector2 = Vector2.ZERO
var _coins_feedback_base_position: Vector2 = Vector2.ZERO
var _playtest_mode: bool = false
var _music_enabled: bool = true
var _sfx_enabled: bool = true
var _is_drop_animating: bool = false
var _is_swap_animating: bool = false
var _pending_drop_animation: Dictionary = {}
var _visual_board_state: BoardState
var _phase_music_path: String = ""


func setup(level_data: Dictionary, session_state: LevelSessionState, runtime_options: Dictionary = {}) -> void:
    _level_data = level_data
    _session_state = session_state
    _selected_position = Vector2i(-1, -1)
    _status_message = "Selecione duas pecas vizinhas para formar combinacoes."
    _has_recorded_victory = false
    _has_played_end_state_sound = false
    _is_paused = false
    _is_drop_animating = false
    _is_swap_animating = false
    _pending_drop_animation.clear()
    _visual_board_state = null
    _phase_music_path = _pick_phase_music_path()
    _playtest_mode = bool(runtime_options.get("playtest_mode", false))
    _music_enabled = bool(runtime_options.get("music_enabled", true))
    _sfx_enabled = bool(runtime_options.get("sfx_enabled", true))
    if _playtest_mode:
        _status_message = "Modo playtest: o save local nao sera alterado nesta fase."
    _hide_end_state()
    _hide_pause_layer()
    if is_node_ready():
        _play_phase_music()
        _apply_level_theme()


func _ready() -> void:
    _initialize_services()
    _restart_button.pressed.connect(_on_restart_pressed)
    _next_button.pressed.connect(_on_next_pressed)
    _pause_button.pressed.connect(_on_pause_pressed)
    _pause_resume_button.pressed.connect(_on_pause_resume_pressed)
    _pause_home_button.pressed.connect(_on_pause_home_pressed)
    _combo_feedback_base_position = _combo_feedback_label.position
    _coins_feedback_base_position = _coins_feedback_label.position
    _combo_feedback_label.modulate.a = 0.0
    _coins_feedback_label.modulate.a = 0.0
    _hide_pause_layer()
    _play_phase_music()
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
    _pause_button.disabled = _session_state.status != "playing" or _is_paused or _is_drop_animating or _is_swap_animating
    _render_grid()
    _refresh_end_state()


func _render_grid() -> void:
    var board_state: BoardState = _get_render_board_state()

    for child in _board_grid.get_children():
        child.queue_free()

    _board_grid.columns = board_state.width

    for row in range(board_state.height):
        for column in range(board_state.width):
            var cell: BoardCell = board_state.get_cell(row, column)
            var piece = board_state.get_piece(row, column)
            if board_state.can_hold_piece(row, column):
                _board_grid.add_child(_build_piece_button(row, column, piece, cell))
            elif board_state.has_cell(row, column):
                _board_grid.add_child(_build_obstacle_cell(cell))
            else:
                _board_grid.add_child(_build_blocked_cell())

    if not _pending_drop_animation.is_empty():
        _play_pending_drop_animation.call_deferred()


func _build_piece_button(row: int, column: int, piece, cell: BoardCell) -> Button:
    var button: Button = Button.new()
    var is_selected: bool = _selected_position == Vector2i(column, row)
    var is_interaction_locked: bool = _is_paused or _is_drop_animating or _is_swap_animating or not _session_state.can_accept_input()
    var style: StyleBoxFlat = StyleBoxFlat.new()

    button.custom_minimum_size = BOARD_CELL_SIZE
    button.focus_mode = Control.FOCUS_NONE
    button.disabled = false
    button.mouse_filter = Control.MOUSE_FILTER_IGNORE if is_interaction_locked else Control.MOUSE_FILTER_STOP
    button.mouse_default_cursor_shape = Control.CURSOR_ARROW if is_interaction_locked else Control.CURSOR_POINTING_HAND
    button.text = ""
    button.icon = _piece_texture(piece)
    button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
    button.expand_icon = false

    style.bg_color = Color(0.15, 0.22, 0.19, 0.82)
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
    button.set_meta("board_position", Vector2i(column, row))
    button.gui_input.connect(_on_piece_gui_input.bind(Vector2i(column, row)))
    _add_piece_overlays(button, piece, cell)

    return button


func _build_blocked_cell() -> Control:
    var panel: Panel = Panel.new()
    var style: StyleBoxFlat = StyleBoxFlat.new()

    panel.custom_minimum_size = BOARD_CELL_SIZE
    style.bg_color = Color(0.09, 0.16, 0.12, 0.45)
    style.corner_radius_top_left = 16
    style.corner_radius_top_right = 16
    style.corner_radius_bottom_right = 16
    style.corner_radius_bottom_left = 16
    panel.add_theme_stylebox_override("panel", style)

    return panel


func _build_obstacle_cell(cell: BoardCell) -> Control:
    var button: Button = Button.new()
    var style: StyleBoxFlat = StyleBoxFlat.new()

    button.custom_minimum_size = BOARD_CELL_SIZE
    button.focus_mode = Control.FOCUS_NONE
    button.disabled = true
    button.mouse_filter = Control.MOUSE_FILTER_STOP
    button.text = ""

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
    var obstacle_badge: Texture2D = _obstacle_badge_texture(cell)
    if obstacle_badge != null:
        var centered_badge := TextureRect.new()
        centered_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
        centered_badge.texture = obstacle_badge
        centered_badge.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        centered_badge.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        centered_badge.custom_minimum_size = Vector2(44, 44)
        centered_badge.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
        centered_badge.position -= centered_badge.custom_minimum_size * 0.5
        button.add_child(centered_badge)

    if cell != null and cell.obstacle_type == BoardCellScript.OBSTACLE_DENSE_GRASS:
        var hits_label := Label.new()
        hits_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
        hits_label.text = str(cell.obstacle_hits_remaining)
        hits_label.add_theme_font_override("font", KENNEY_FONT_TITLE)
        hits_label.add_theme_font_size_override("font_size", 18)
        hits_label.add_theme_color_override("font_color", Color("fffaf1"))
        hits_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.7))
        hits_label.add_theme_constant_override("shadow_offset_x", 1)
        hits_label.add_theme_constant_override("shadow_offset_y", 1)
        hits_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
        hits_label.position += Vector2(-12, -12)
        button.add_child(hits_label)

    return button


func _on_piece_pressed(position: Vector2i) -> void:
    if _is_paused or _is_drop_animating or _is_swap_animating or not _session_state.can_accept_input():
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

    var first_position: Vector2i = _selected_position
    var swap_targets: Dictionary = await _play_swap_animation(first_position, position)
    var result: Dictionary = _apply_swap_use_case.execute(_session_state, first_position, position)
    _selected_position = Vector2i(-1, -1)
    _status_message = String(result.get("message", "Jogada processada."))
    _play_resolution_sound(result)
    if bool(result.get("accepted", false)):
        if not _playtest_mode:
            _level_progress_use_case.award_coins(int(result.get("coins_earned", 0)))

        await _play_cascade_resolution(result.get("cascade_steps", []))
    elif not swap_targets.is_empty():
        await _play_swap_return_animation(swap_targets)

    _is_swap_animating = false
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


func _piece_texture(piece) -> Texture2D:
    if piece == null:
        return null

    return _piece_texture_for_color(piece.color_id)


func _piece_texture_for_color(color_id: String) -> Texture2D:
    match color_id:
        "yellow":
            return GEM_YELLOW
        "red":
            return GEM_RED
        "green":
            return GEM_GREEN
        "blue":
            return GEM_BLUE

    return GEM_YELLOW


func _add_piece_overlays(button: Button, piece, cell: BoardCell) -> void:
    var special_badge: Texture2D = _piece_special_badge_texture(piece)
    if special_badge != null:
        button.add_child(_build_badge_texture_rect(special_badge, true))

    var obstacle_badge: Texture2D = _obstacle_badge_texture(cell)
    if obstacle_badge != null:
        button.add_child(_build_badge_texture_rect(obstacle_badge, false))


func _piece_special_badge_texture(piece) -> Texture2D:
    if piece == null:
        return null

    if piece.special_type == BoardPieceScript.SPECIAL_MISSILE_HORIZONTAL:
        return SPECIAL_BADGE_FOUR_HORIZONTAL

    if piece.special_type == BoardPieceScript.SPECIAL_MISSILE_VERTICAL:
        return SPECIAL_BADGE_FOUR_VERTICAL

    if piece.special_type == BoardPieceScript.SPECIAL_RAINBOW:
        return SPECIAL_BADGE_FIVE

    return null


func _obstacle_badge_texture(cell: BoardCell) -> Texture2D:
    if cell == null or not cell.has_obstacle():
        return null

    if cell.obstacle_type == BoardCellScript.OBSTACLE_BOX:
        return OBSTACLE_BADGE_BOX

    if cell.obstacle_type == BoardCellScript.OBSTACLE_ICE:
        return OBSTACLE_BADGE_ICE

    if cell.obstacle_type == BoardCellScript.OBSTACLE_GRASS:
        return OBSTACLE_BADGE_GRASS

    if cell.obstacle_type == BoardCellScript.OBSTACLE_DENSE_GRASS:
        return OBSTACLE_BADGE_DENSE_GRASS

    return OBSTACLE_BADGE_BOX


func _build_badge_texture_rect(texture: Texture2D, align_right: bool) -> TextureRect:
    var badge := TextureRect.new()
    badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
    badge.texture = texture
    badge.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    badge.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    badge.custom_minimum_size = Vector2(24, 24)
    badge.position = Vector2(82, 6) if align_right else Vector2(6, 6)
    badge.size = Vector2(24, 24)
    return badge


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
        _show_end_state("Fase perdida", "As jogadas acabaram. Leia o resumo e use o botao abaixo para voltar ao home.", true, false, "Voltar ao home")
        return

    _hide_end_state()


func _handle_victory() -> void:
    var next_level_id: String = _find_next_level_id(_session_state.level_id)
    if not _playtest_mode and not _has_recorded_victory:
        _level_progress_use_case.record_victory(_session_state.level_id, next_level_id)
        _has_recorded_victory = true

    var message: String = ""
    if _playtest_mode:
        message = "Objetivos concluidos em modo playtest. O progresso local nao foi alterado."
        if next_level_id != "":
            message += " Use o home para abrir rapidamente a proxima fase que quiser revisar."
    else:
        message = "Objetivos concluidos. Progresso salvo localmente."
        if next_level_id != "":
            message += " A proxima fase ja foi desbloqueada no home."
        else:
            message += " Voce concluiu o pacote tecnico atual."

    message += " Quando terminar de ler, use o botao abaixo para voltar ao home."
    _play_end_state_sound(true)
    _show_end_state("Fase vencida", message, true, false, "Voltar ao home")


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

    if not _playtest_mode:
        _level_progress_use_case.record_opened_level(level_id)

    setup(
        payload["level_data"],
        payload["session_state"],
        {
            "playtest_mode": _playtest_mode,
            "music_enabled": _music_enabled,
            "sfx_enabled": _sfx_enabled
        }
    )
    _refresh_view()


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


func _pick_phase_music_path() -> String:
    if MUSIC_BOARD_PATHS.is_empty():
        return ""

    var rng := RandomNumberGenerator.new()
    rng.randomize()
    return String(MUSIC_BOARD_PATHS[rng.randi_range(0, MUSIC_BOARD_PATHS.size() - 1)])


func _play_phase_music() -> void:
    if not _music_enabled:
        if _music_player != null:
            _music_player.stop()
        return

    if _phase_music_path == "":
        _phase_music_path = _pick_phase_music_path()

    _play_music_from_file(_phase_music_path, -20.0)


func _get_render_board_state() -> BoardState:
    if _visual_board_state != null:
        return _visual_board_state

    return _session_state.board_state


func _capture_piece_positions(board_state: BoardState) -> Dictionary:
    var positions: Dictionary = {}

    for row in range(board_state.height):
        for column in range(board_state.width):
            var piece = board_state.get_piece(row, column)
            if piece == null:
                continue

            positions[piece.uid] = Vector2i(column, row)

    return positions


func _build_drop_animation(previous_state: BoardState, current_state: BoardState) -> Dictionary:
    var previous_piece_positions: Dictionary = _capture_piece_positions(previous_state)
    var animation_map: Dictionary = {}
    var spawned_rows_by_column: Dictionary = {}

    for row in range(current_state.height):
        for column in range(current_state.width):
            var piece = current_state.get_piece(row, column)
            if piece == null:
                continue

            var target_position: Vector2i = Vector2i(column, row)
            var piece_id: int = piece.uid
            if previous_piece_positions.has(piece_id):
                var previous_position: Vector2i = previous_piece_positions[piece_id]
                if previous_position.y < row:
                    animation_map[target_position] = previous_position.y
                continue

            if not spawned_rows_by_column.has(column):
                spawned_rows_by_column[column] = []

            var spawned_rows: Array = spawned_rows_by_column[column]
            spawned_rows.append(row)

    for column in spawned_rows_by_column.keys():
        var spawned_rows: Array = spawned_rows_by_column[column]
        spawned_rows.sort()
        var total_spawned: int = spawned_rows.size()
        for index in range(total_spawned):
            var row: int = spawned_rows[index]
            animation_map[Vector2i(column, row)] = -total_spawned + index

    return animation_map


func _play_cascade_resolution(cascade_steps: Array) -> void:
    if cascade_steps.is_empty():
        return

    _is_drop_animating = true
    for raw_step in cascade_steps:
        if raw_step is not Dictionary:
            continue

        var step: Dictionary = raw_step
        var before_clear_snapshot: BoardState = step.get("before_clear_snapshot", null)
        var after_clear_snapshot: BoardState = step.get("after_clear_snapshot", null)
        var after_fall_snapshot: BoardState = step.get("after_fall_snapshot", null)
        var cleared_positions: Array = step.get("cleared_positions", [])

        _visual_board_state = before_clear_snapshot
        _refresh_view()
        _show_chain_step_feedback(step)
        await _play_pop_clear_animation(cleared_positions)

        _visual_board_state = after_clear_snapshot
        _refresh_view()
        await get_tree().create_timer(CASCADE_STEP_PAUSE).timeout

        _visual_board_state = after_fall_snapshot
        _pending_drop_animation = _build_drop_animation(after_clear_snapshot, after_fall_snapshot)
        _refresh_view()
        await _play_pending_drop_animation()
        await get_tree().create_timer(CASCADE_STEP_PAUSE).timeout

    _is_drop_animating = false
    _pending_drop_animation.clear()
    _visual_board_state = null
    _refresh_view()


func _play_pop_clear_animation(cleared_positions: Array) -> void:
    if cleared_positions.is_empty():
        return

    await get_tree().process_frame
    if not is_inside_tree():
        return

    var tween := create_tween()
    tween.set_parallel(true)
    for raw_position in cleared_positions:
        if raw_position is not Vector2i:
            continue

        var piece_button: Button = _find_piece_button(raw_position)
        if piece_button == null:
            continue

        piece_button.scale = Vector2.ONE
        piece_button.modulate = Color(1, 1, 1, 1)
        tween.tween_property(piece_button, "scale", Vector2(1.08, 1.08), POP_ANIMATION_GROW_DURATION).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
        tween.tween_property(piece_button, "scale", Vector2(0.22, 0.22), POP_ANIMATION_SHRINK_DURATION).set_delay(POP_ANIMATION_GROW_DURATION).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
        tween.tween_property(piece_button, "modulate:a", 0.0, POP_ANIMATION_GROW_DURATION + POP_ANIMATION_SHRINK_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

    await tween.finished


func _play_pending_drop_animation() -> void:
    if _pending_drop_animation.is_empty() or not is_inside_tree():
        return

    await get_tree().process_frame
    if not is_inside_tree():
        return

    var tween := create_tween()
    tween.set_parallel(true)
    for child in _board_grid.get_children():
        if not (child is Button):
            continue
        if not child.has_meta("board_position"):
            continue

        var board_position: Vector2i = child.get_meta("board_position")
        if not _pending_drop_animation.has(board_position):
            continue

        var start_row: int = int(_pending_drop_animation[board_position])
        var row_distance: int = max(1, board_position.y - start_row)
        var target_position: Vector2 = child.position
        var start_position := Vector2(
            target_position.x,
            target_position.y - (float(row_distance) * (BOARD_CELL_SIZE.y + BOARD_CELL_SPACING))
        )
        var duration: float = min(DROP_ANIMATION_MAX_DURATION, DROP_ANIMATION_MIN_DURATION + (0.03 * row_distance))

        child.position = start_position
        child.scale = Vector2.ONE
        child.modulate = Color(1, 1, 1, 0.72)
        tween.tween_property(child, "position", target_position, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
        tween.tween_property(child, "modulate:a", 1.0, duration * 0.75).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

    await tween.finished
    _pending_drop_animation.clear()


func _play_swap_animation(first_position: Vector2i, second_position: Vector2i) -> Dictionary:
    var first_button: Button = _find_piece_button(first_position)
    var second_button: Button = _find_piece_button(second_position)
    if first_button == null or second_button == null:
        return {}

    _is_swap_animating = true
    var first_origin: Vector2 = first_button.position
    var second_origin: Vector2 = second_button.position
    var tween := create_tween()
    tween.set_parallel(true)
    tween.tween_property(first_button, "position", second_origin, SWAP_ANIMATION_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    tween.tween_property(second_button, "position", first_origin, SWAP_ANIMATION_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    await tween.finished

    return {
        "first_button": first_button,
        "second_button": second_button,
        "first_origin": first_origin,
        "second_origin": second_origin
    }


func _play_swap_return_animation(swap_targets: Dictionary) -> void:
    if swap_targets.is_empty():
        return

    var first_button: Button = swap_targets.get("first_button", null)
    var second_button: Button = swap_targets.get("second_button", null)
    if first_button == null or second_button == null:
        return

    var tween := create_tween()
    tween.set_parallel(true)
    tween.tween_property(first_button, "position", swap_targets.get("first_origin", first_button.position), SWAP_ANIMATION_DURATION * 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    tween.tween_property(second_button, "position", swap_targets.get("second_origin", second_button.position), SWAP_ANIMATION_DURATION * 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    await tween.finished


func _find_piece_button(board_position: Vector2i) -> Button:
    for child in _board_grid.get_children():
        if child is not Button:
            continue
        if not child.has_meta("board_position"):
            continue
        if child.get_meta("board_position") == board_position:
            return child

    return null


func _show_chain_step_feedback(step: Dictionary) -> void:
    var cascade_index: int = int(step.get("cascade_index", 1))
    var removed_count: int = int(step.get("removed_count", 0))
    var coins_earned: int = int(step.get("coins_earned", 0))
    var chain_message: String = "Combinacao!"

    if cascade_index >= 3:
        chain_message = "Chain x%s" % cascade_index
    elif cascade_index == 2:
        chain_message = "Chain x2"
    elif removed_count >= 8:
        chain_message = "Boa jogada!"

    _show_feedback_label(_combo_feedback_label, _combo_feedback_base_position, chain_message)
    if coins_earned > 0:
        _show_feedback_label(_coins_feedback_label, _coins_feedback_base_position, "+%s moedas" % coins_earned)


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


func _show_feedback_label(target: Label, base_position: Vector2, message: String) -> void:
    target.text = message
    target.position = base_position
    target.modulate = Color(1, 1, 1, 0)
    target.scale = Vector2(0.92, 0.92)

    var tween := create_tween()
    tween.set_parallel(true)
    tween.tween_property(target, "modulate:a", 1.0, 0.12)
    tween.tween_property(target, "scale", Vector2(1, 1), 0.16)
    tween.chain().tween_interval(0.55)
    tween.chain().set_parallel(true)
    tween.tween_property(target, "modulate:a", 0.0, 0.28)
    tween.tween_property(target, "position:y", base_position.y - 12.0, 0.28)


func _apply_level_theme() -> void:
    if not is_node_ready():
        return

    var palette: Dictionary = _build_theme_palette(String(_level_data.get("theme_id", "mata_clara")))
    _background.color = palette["background"]
    _apply_font_style(_title_label, KENNEY_FONT_TITLE)
    _apply_font_style(_moves_label, KENNEY_FONT_BODY)
    _apply_font_style(_goal_label, KENNEY_FONT_BODY)
    _apply_font_style(_status_label, KENNEY_FONT_BODY)
    _apply_font_style(_combo_feedback_label, KENNEY_FONT_TITLE)
    _apply_font_style(_coins_feedback_label, KENNEY_FONT_BODY)
    _apply_font_style(_pause_title_label, KENNEY_FONT_TITLE)
    _apply_font_style(_pause_message_label, KENNEY_FONT_BODY)
    _apply_font_style(_end_state_title_label, KENNEY_FONT_TITLE)
    _apply_font_style(_end_state_message_label, KENNEY_FONT_BODY)
    _title_label.add_theme_color_override("font_color", palette["title"])
    _moves_label.add_theme_color_override("font_color", palette["hud"])
    _goal_label.add_theme_color_override("font_color", palette["hud"])
    _status_label.add_theme_color_override("font_color", palette["body"])
    _combo_feedback_label.add_theme_color_override("font_color", palette["title"])
    _coins_feedback_label.add_theme_color_override("font_color", Color("f7c948"))
    _pause_title_label.add_theme_color_override("font_color", palette["title"])
    _pause_message_label.add_theme_color_override("font_color", palette["body"])
    _end_state_title_label.add_theme_color_override("font_color", palette["title"])
    _end_state_message_label.add_theme_color_override("font_color", palette["body"])

    _apply_panel_style(_glow_orb, palette["glow"], palette["glow"], 999)
    _apply_panel_style(_leaf_glow_left, palette["leaf_primary"], palette["leaf_primary"], 180)
    _apply_panel_style(_leaf_glow_right, palette["leaf_secondary"], palette["leaf_secondary"], 180)
    _apply_texture_panel_style(_board_shell)
    _apply_texture_panel_style(_pause_panel)
    _apply_texture_panel_style(_end_state_panel)
    _apply_kenney_button_style(_pause_button, KENNEY_BUTTON_SECONDARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_pause_resume_button, KENNEY_BUTTON_PRIMARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_pause_home_button, KENNEY_BUTTON_SECONDARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_restart_button, KENNEY_BUTTON_PRIMARY, BUTTON_TEXT_DARK)
    _apply_kenney_button_style(_next_button, KENNEY_BUTTON_DANGER, BUTTON_TEXT_DARK)
    _pause_resume_button.icon = KENNEY_ICON_PLAY
    _pause_home_button.icon = KENNEY_ICON_ARROW_LEFT
    _restart_button.icon = KENNEY_ICON_ARROW_LEFT
    _next_button.icon = KENNEY_ICON_REPEAT


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


func _find_next_level_id(level_id: String) -> String:
    if not level_id.begins_with("level_"):
        return ""

    var numeric_part: String = level_id.trim_prefix("level_")
    if not numeric_part.is_valid_int():
        return ""

    var next_level_id: String = "level_%03d" % [int(numeric_part) + 1]
    var next_level_data: Dictionary = _level_repository.fetch_by_id(next_level_id)
    return next_level_id if not next_level_data.is_empty() else ""
