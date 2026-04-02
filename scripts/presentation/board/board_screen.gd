extends Control
class_name BoardScreen

const ApplySwapUseCaseScript = preload("res://scripts/application/use_cases/apply_swap_use_case.gd")
const BoardGeneratorScript = preload("res://scripts/domain/board/services/board_generator.gd")
const BoardCellScript = preload("res://scripts/domain/board/models/board_cell.gd")
const BoardPieceScript = preload("res://scripts/domain/board/models/board_piece.gd")
const GravityResolverScript = preload("res://scripts/domain/board/services/gravity_resolver.gd")
const MatchFinderScript = preload("res://scripts/domain/board/services/match_finder.gd")
const ObstacleResolverScript = preload("res://scripts/domain/board/services/obstacle_resolver.gd")
const PossibleMoveFinderScript = preload("res://scripts/domain/board/services/possible_move_finder.gd")
const SpecialPieceResolverScript = preload("res://scripts/domain/board/services/special_piece_resolver.gd")

@onready var _title_label: Label = $MarginContainer/RootColumn/TitleLabel
@onready var _moves_label: Label = $MarginContainer/RootColumn/HudRow/MovesLabel
@onready var _goal_label: Label = $MarginContainer/RootColumn/HudRow/GoalLabel
@onready var _status_label: Label = $MarginContainer/RootColumn/StatusLabel
@onready var _board_grid: GridContainer = $MarginContainer/RootColumn/BoardGrid

var _session_state: LevelSessionState
var _level_data: Dictionary = {}
var _selected_position: Vector2i = Vector2i(-1, -1)
var _status_message: String = "Carregando tabuleiro..."
var _board_generator
var _apply_swap_use_case


func setup(level_data: Dictionary, session_state: LevelSessionState) -> void:
    _level_data = level_data
    _session_state = session_state
    _status_message = "Selecione duas pecas vizinhas para formar combinacoes."


func _ready() -> void:
    _initialize_services()
    _refresh_view()


func _initialize_services() -> void:
    if _board_generator == null:
        _board_generator = BoardGeneratorScript.new()

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
        return

    _title_label.text = String(_level_data.get("name", "Aldeia das Cores"))
    _moves_label.text = "Jogadas: %s" % _session_state.moves_remaining
    _goal_label.text = _build_goal_text()
    _status_label.text = _status_message
    _render_grid()


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

    button.custom_minimum_size = Vector2(96, 96)
    button.focus_mode = Control.FOCUS_NONE
    button.disabled = not _session_state.can_accept_input()
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
    elif cell != null and cell.obstacle_type == BoardCellScript.OBSTACLE_ICE and cell.has_obstacle():
        style.border_color = Color("8bd3ff")
        style.bg_color = style.bg_color.lerp(Color("dff4ff"), 0.35)
    else:
        style.border_color = Color(0.08, 0.16, 0.12, 0.5)

    button.add_theme_stylebox_override("normal", style)
    button.add_theme_stylebox_override("hover", style)
    button.add_theme_stylebox_override("pressed", style)
    button.add_theme_font_size_override("font_size", 18 if cell != null and cell.obstacle_type == BoardCellScript.OBSTACLE_ICE and cell.has_obstacle() else 22)
    button.gui_input.connect(_on_piece_gui_input.bind(Vector2i(column, row)))

    return button


func _build_blocked_cell() -> Control:
    var panel: Panel = Panel.new()
    var style: StyleBoxFlat = StyleBoxFlat.new()

    panel.custom_minimum_size = Vector2(96, 96)
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

    button.custom_minimum_size = Vector2(96, 96)
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
    if not _session_state.can_accept_input():
        return

    if _selected_position == Vector2i(-1, -1):
        _selected_position = position
        _status_message = "Peca selecionada. Escolha uma gema vizinha."
        _refresh_view()
        return

    if position == _selected_position:
        _selected_position = Vector2i(-1, -1)
        _status_message = "Selecao cancelada."
        _refresh_view()
        return

    if not _is_adjacent(_selected_position, position):
        _selected_position = position
        _status_message = "Selecione uma segunda gema vizinha."
        _refresh_view()
        return

    var result: Dictionary = _apply_swap_use_case.execute(_session_state, _selected_position, position)
    _selected_position = Vector2i(-1, -1)
    _status_message = String(result.get("message", "Jogada processada."))
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

    if cell != null and cell.obstacle_type == BoardCellScript.OBSTACLE_ICE and cell.has_obstacle():
        symbol = "GE %s" % symbol

    return "%s%s" % [prefix, symbol]


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
