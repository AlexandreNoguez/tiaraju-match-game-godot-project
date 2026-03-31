extends RefCounted
class_name ApplySwapUseCase

var _match_finder: MatchFinder
var _gravity_resolver: GravityResolver
var _possible_move_finder: PossibleMoveFinder
var _board_generator: BoardGenerator


func _init(
    match_finder: MatchFinder,
    gravity_resolver: GravityResolver,
    possible_move_finder: PossibleMoveFinder,
    board_generator: BoardGenerator
) -> void:
    _match_finder = match_finder
    _gravity_resolver = gravity_resolver
    _possible_move_finder = possible_move_finder
    _board_generator = board_generator


func execute(session_state: LevelSessionState, first_position: Vector2i, second_position: Vector2i) -> Dictionary:
    if not session_state.can_accept_input():
        return _rejected("session_locked", "A fase ja foi encerrada.")

    var board_state := session_state.board_state

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
    var removed_color_counts := {}

    while not matches.is_empty():
        cascade_count += 1
        var resolution := _gravity_resolver.clear_matches_and_refill(board_state, matches)
        var cleared_positions := resolution.get("positions", [])
        removed_count += cleared_positions.size()
        _merge_color_counts(removed_color_counts, resolution.get("color_counts", {}))
        matches = _match_finder.find_matches(board_state)

    session_state.consume_move()
    session_state.register_removed_colors(removed_color_counts)

    var board_rerolled := false
    if not _possible_move_finder.has_possible_moves(board_state):
        _board_generator.reroll_board(board_state)
        board_rerolled = true

    session_state.update_status_after_turn()

    var message := "Jogada valida. %s pecas removidas em %s cascata(s)." % [removed_count, cascade_count]
    if board_rerolled:
        message += " Tabuleiro reorganizado por falta de jogadas possiveis."

    if session_state.status == "victory":
        message = "Voce venceu a fase!"
    elif session_state.status == "defeat":
        message = "Fim das jogadas. Tente novamente."

    return {
        "accepted": true,
        "reason": "ok",
        "cascade_count": cascade_count,
        "removed_count": removed_count,
        "removed_color_counts": removed_color_counts,
        "board_rerolled": board_rerolled,
        "status": session_state.status,
        "moves_remaining": session_state.moves_remaining,
        "message": message
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


func _merge_color_counts(target: Dictionary, source: Dictionary) -> void:
    for color_key in source.keys():
        target[color_key] = int(target.get(color_key, 0)) + int(source[color_key])


func _rejected(reason: String, message: String) -> Dictionary:
    return {
        "accepted": false,
        "reason": reason,
        "message": message
    }
