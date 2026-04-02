extends RefCounted
class_name ApplySwapUseCase

const BoardPiece = preload("res://scripts/domain/board/models/board_piece.gd")

var _match_finder: MatchFinder
var _gravity_resolver: GravityResolver
var _obstacle_resolver
var _possible_move_finder: PossibleMoveFinder
var _board_generator: BoardGenerator
var _special_piece_resolver


func configure(
    match_finder: MatchFinder,
    gravity_resolver: GravityResolver,
    obstacle_resolver,
    possible_move_finder: PossibleMoveFinder,
    board_generator: BoardGenerator,
    special_piece_resolver
) -> void:
    _match_finder = match_finder
    _gravity_resolver = gravity_resolver
    _obstacle_resolver = obstacle_resolver
    _possible_move_finder = possible_move_finder
    _board_generator = board_generator
    _special_piece_resolver = special_piece_resolver


func execute(session_state: LevelSessionState, first_position: Vector2i, second_position: Vector2i) -> Dictionary:
    if not session_state.can_accept_input():
        return _rejected("session_locked", "A fase ja foi encerrada.")

    var board_state: BoardState = session_state.board_state

    if not _is_adjacent(first_position, second_position):
        return _rejected("not_adjacent", "Selecione duas pecas vizinhas.")

    if not _can_swap(board_state, first_position, second_position):
        return _rejected("invalid_positions", "Nao foi possivel trocar essas pecas.")

    board_state.swap_pieces(first_position, second_position)

    var matches: Array = _match_finder.find_matches(board_state)
    if matches.is_empty():
        var special_activation: Dictionary = _special_piece_resolver.build_swap_special_activation(
            board_state,
            first_position,
            second_position
        )
        if special_activation.is_empty():
            board_state.swap_pieces(first_position, second_position)
            return _rejected("no_match", "A troca nao formou uma combinacao valida.")

        matches = []

    var cascade_count: int = 0
    var removed_count: int = 0
    var removed_color_counts: Dictionary = {}
    var removed_obstacle_counts: Dictionary = {}
    var special_message: String = ""
    var cascade_steps: Array = []
    var coins_earned: int = 0

    while true:
        cascade_count += 1
        var before_clear_snapshot: BoardState = board_state.duplicate_state()
        var positions_to_clear: Array = []
        var adjacent_damage_sources: Array = []
        var spawned_specials: Dictionary = {}

        if not matches.is_empty():
            spawned_specials = _special_piece_resolver.build_spawned_specials(matches, [second_position, first_position])
            positions_to_clear = _collect_cleared_positions(matches, spawned_specials)
            adjacent_damage_sources = positions_to_clear.duplicate()
        else:
            var special_activation: Dictionary = _special_piece_resolver.build_swap_special_activation(
                board_state,
                first_position,
                second_position
            )
            positions_to_clear = special_activation.get("positions", [])
            special_message = String(special_activation.get("message", "Especial ativado!"))

        positions_to_clear = _special_piece_resolver.expand_positions_with_specials(board_state, positions_to_clear)
        var obstacle_resolution: Dictionary = _obstacle_resolver.apply_damage(
            board_state,
            positions_to_clear,
            adjacent_damage_sources
        )
        _merge_color_counts(removed_obstacle_counts, obstacle_resolution.get("removed_counts", {}))
        var after_clear_snapshot: BoardState = _build_after_clear_snapshot(board_state, positions_to_clear, spawned_specials)
        var resolution: Dictionary = _gravity_resolver.clear_positions_and_refill(board_state, positions_to_clear, spawned_specials)
        var cleared_positions: Array = resolution.get("positions", [])
        removed_count += cleared_positions.size()
        _merge_color_counts(removed_color_counts, resolution.get("color_counts", {}))
        var after_fall_snapshot: BoardState = board_state.duplicate_state()
        var cascade_coins: int = _coins_for_cascade(cascade_count, cleared_positions.size())
        coins_earned += cascade_coins
        cascade_steps.append(
            {
                "cascade_index": cascade_count,
                "cleared_positions": cleared_positions,
                "removed_count": cleared_positions.size(),
                "coins_earned": cascade_coins,
                "before_clear_snapshot": before_clear_snapshot,
                "after_clear_snapshot": after_clear_snapshot,
                "after_fall_snapshot": after_fall_snapshot
            }
        )
        matches = _match_finder.find_matches(board_state)

        if matches.is_empty():
            break

    session_state.consume_move()
    session_state.register_removed_colors(removed_color_counts)
    session_state.register_removed_obstacles(removed_obstacle_counts)

    var board_rerolled: bool = false
    if not _possible_move_finder.has_possible_moves(board_state):
        _board_generator.reroll_board(board_state)
        board_rerolled = true

    session_state.update_status_after_turn()

    var message: String = "Jogada valida. %s pecas removidas em %s cascata(s)." % [removed_count, cascade_count]
    if special_message != "":
        message = "%s %s" % [special_message, message]
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
        "removed_obstacle_counts": removed_obstacle_counts,
        "board_rerolled": board_rerolled,
        "cascade_steps": cascade_steps,
        "coins_earned": coins_earned,
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
    var distance: int = absi(first_position.x - second_position.x) + absi(first_position.y - second_position.y)
    return distance == 1


func _merge_color_counts(target: Dictionary, source: Dictionary) -> void:
    for color_key in source.keys():
        target[color_key] = int(target.get(color_key, 0)) + int(source[color_key])


func _collect_cleared_positions(matches: Array, spawned_specials: Dictionary) -> Array[Vector2i]:
    var positions: Array[Vector2i] = []

    for match_data in matches:
        for raw_position in match_data.get("cells", []):
            if raw_position is Vector2i:
                var position: Vector2i = raw_position
                if not spawned_specials.has(position):
                    positions.append(position)

    return positions


func _build_after_clear_snapshot(board_state: BoardState, positions_to_clear: Array, spawned_specials: Dictionary) -> BoardState:
    var snapshot: BoardState = board_state.duplicate_state()
    for raw_position in positions_to_clear:
        if raw_position is not Vector2i:
            continue

        var position: Vector2i = raw_position
        snapshot.set_piece(position.y, position.x, null)

    for raw_position in spawned_specials.keys():
        var position: Vector2i = raw_position
        var special_data: Dictionary = spawned_specials[raw_position]
        snapshot.set_piece(
            position.y,
            position.x,
            BoardPiece.new(
                String(special_data.get("color_id", "yellow")),
                String(special_data.get("special_type", BoardPiece.SPECIAL_NONE))
            )
        )

    return snapshot


func _coins_for_cascade(cascade_index: int, cleared_count: int) -> int:
    var coins: int = max(1, cascade_index)
    if cleared_count >= 8:
        coins += 1
    return coins


func _rejected(reason: String, message: String) -> Dictionary:
    return {
        "accepted": false,
        "reason": reason,
        "message": message
    }
