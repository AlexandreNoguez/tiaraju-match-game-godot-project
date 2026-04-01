extends RefCounted
class_name PossibleMoveFinder

var _match_finder: MatchFinder


func _init(match_finder: MatchFinder) -> void:
    _match_finder = match_finder


func has_possible_moves(board_state: BoardState) -> bool:
    return not find_possible_moves(board_state).is_empty()


func find_possible_moves(board_state: BoardState) -> Array:
    var moves: Array = []
    var directions: Array[Vector2i] = [Vector2i(1, 0), Vector2i(0, 1)]

    for position in board_state.get_playable_positions():
        for direction in directions:
            var target: Vector2i = position + direction
            if not board_state.has_cell(target.y, target.x):
                continue

            board_state.swap_pieces(position, target)
            var matches: Array = _match_finder.find_matches(board_state)
            board_state.swap_pieces(position, target)

            if not matches.is_empty():
                moves.append(
                    {
                        "from": position,
                        "to": target
                    }
                )

    return moves
