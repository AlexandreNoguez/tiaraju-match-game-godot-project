extends RefCounted
class_name ApplySwapUseCase

var _match_finder: MatchFinder
var _gravity_resolver: GravityResolver


func _init(match_finder: MatchFinder, gravity_resolver: GravityResolver) -> void:
    _match_finder = match_finder
    _gravity_resolver = gravity_resolver


func execute(board_state: BoardState, first_position: Vector2i, second_position: Vector2i) -> Dictionary:
    if not _is_adjacent(first_position, second_position):
        return _rejected("not_adjacent", "Selecione duas pecas vizinhas.")

    if not _can_swap(board_state, first_position, second_position):
        return _rejected("invalid_positions", "Nao foi possivel trocar essas pecas.")

    board_state.swap_pieces(first_position, second_position)

    var matches := _match_finder.find_matches(board_state)
    if matches.is_empty():
        board_state.swap_pieces(first_position, second_position)
        return _rejected("no_match", "A troca nao formou uma combinacao valida.")

    var cascade_count := 0
    var removed_count := 0

    while not matches.is_empty():
        cascade_count += 1
        var cleared_positions := _gravity_resolver.clear_matches_and_refill(board_state, matches)
        removed_count += cleared_positions.size()
        matches = _match_finder.find_matches(board_state)

    return {
        "accepted": true,
        "reason": "ok",
        "cascade_count": cascade_count,
        "removed_count": removed_count,
        "message": "Jogada valida. %s pecas removidas em %s cascata(s)." % [removed_count, cascade_count]
    }


func _can_swap(board_state: BoardState, first_position: Vector2i, second_position: Vector2i) -> bool:
    if not board_state.has_cell(first_position.y, first_position.x):
        return false

    if not board_state.has_cell(second_position.y, second_position.x):
        return false

    return board_state.get_piece(first_position.y, first_position.x) != null and board_state.get_piece(second_position.y, second_position.x) != null


func _is_adjacent(first_position: Vector2i, second_position: Vector2i) -> bool:
    var distance := abs(first_position.x - second_position.x) + abs(first_position.y - second_position.y)
    return distance == 1


func _rejected(reason: String, message: String) -> Dictionary:
    return {
        "accepted": false,
        "reason": reason,
        "message": message
    }
