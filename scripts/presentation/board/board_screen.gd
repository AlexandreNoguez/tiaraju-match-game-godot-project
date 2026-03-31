extends Control
class_name BoardScreen

const ApplySwapUseCase = preload("res://scripts/application/use_cases/apply_swap_use_case.gd")
const BoardGenerator = preload("res://scripts/domain/board/services/board_generator.gd")
const GravityResolver = preload("res://scripts/domain/board/services/gravity_resolver.gd")
const MatchFinder = preload("res://scripts/domain/board/services/match_finder.gd")
const PossibleMoveFinder = preload("res://scripts/domain/board/services/possible_move_finder.gd")

@onready var _title_label: Label = $MarginContainer/RootColumn/TitleLabel
@onready var _moves_label: Label = $MarginContainer/RootColumn/HudRow/MovesLabel
@onready var _goal_label: Label = $MarginContainer/RootColumn/HudRow/GoalLabel
@onready var _status_label: Label = $MarginContainer/RootColumn/StatusLabel
@onready var _board_grid: GridContainer = $MarginContainer/RootColumn/BoardGrid

var _session_state: LevelSessionState
var _level_data: Dictionary = {}
var _selected_position := Vector2i(-1, -1)
var _status_message := "Carregando tabuleiro..."
var _board_generator := BoardGenerator.new()
var _apply_swap_use_case := ApplySwapUseCase.new(
    MatchFinder.new(),
    GravityResolver.new(),
    PossibleMoveFinder.new(MatchFinder.new()),
    _board_generator
)


func setup(level_data: Dictionary, session_state: LevelSessionState) -> void:
    _level_data = level_data
    _session_state = session_state
    _status_message = "Selecione duas pecas vizinhas para formar combinacoes."


func _ready() -> void:
    _refresh_view()


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
            if _session_state.board_state.has_cell(row, column):
                _board_grid.add_child(_build_piece_button(row, column))
            else:
                _board_grid.add_child(_build_blocked_cell())


func _build_piece_button(row: int, column: int) -> Button:
    var button := Button.new()
    var piece = _session_state.board_state.get_piece(row, column)
    var is_selected := _selected_position == Vector2i(column, row)
    var style := StyleBoxFlat.new()

    button.custom_minimum_size = Vector2(96, 96)
    button.focus_mode = Control.FOCUS_NONE
    button.disabled = not _session_state.can_accept_input()
    button.text = _piece_label(piece, is_selected)

    style.bg_color = _piece_color(piece)
    style.corner_radius_top_left = 16
    style.corner_radius_top_right = 16
    style.corner_radius_bottom_right = 16
    style.corner_radius_bottom_left = 16
    style.border_width_left = 4
    style.border_width_top = 4
    style.border_width_right = 4
    style.border_width_bottom = 4
    style.border_color = Color(1, 1, 1, 0.95) if is_selected else Color(0.08, 0.16, 0.12, 0.5)

    button.add_theme_stylebox_override("normal", style)
    button.add_theme_stylebox_override("hover", style)
    button.add_theme_stylebox_override("pressed", style)
    button.add_theme_font_size_override("font_size", 22)
    button.pressed.connect(_on_piece_pressed.bind(Vector2i(column, row)))

    return button


func _build_blocked_cell() -> Control:
    var panel := Panel.new()
    var style := StyleBoxFlat.new()

    panel.custom_minimum_size = Vector2(96, 96)
    style.bg_color = Color(0.09, 0.16, 0.12, 0.45)
    style.corner_radius_top_left = 16
    style.corner_radius_top_right = 16
    style.corner_radius_bottom_right = 16
    style.corner_radius_bottom_left = 16
    panel.add_theme_stylebox_override("panel", style)

    return panel


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

    var result := _apply_swap_use_case.execute(_session_state, _selected_position, position)
    _selected_position = Vector2i(-1, -1)
    _status_message = String(result.get("message", "Jogada processada."))
    _refresh_view()


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


func _piece_label(piece, is_selected: bool) -> String:
    if piece == null:
        return ""

    var prefix := "> " if is_selected else ""
    return "%s%s" % [prefix, piece.color_id.substr(0, 1).to_upper()]


func _is_adjacent(first_position: Vector2i, second_position: Vector2i) -> bool:
    var distance := abs(first_position.x - second_position.x) + abs(first_position.y - second_position.y)
    return distance == 1


func _build_goal_text() -> String:
    if _session_state.goals.is_empty():
        return "Objetivo: livre"

    var parts := []

    for goal in _session_state.goals:
        if goal.get("type", "") == "collect_color":
            parts.append(
                "%s %s/%s" % [
                    String(goal.get("color", "")).capitalize(),
                    int(goal.get("current_amount", 0)),
                    int(goal.get("target_amount", 0))
                ]
            )

    return "Objetivo: %s" % ", ".join(parts)
