extends RefCounted
class_name GravityResolver

const BoardPiece = preload("res://scripts/domain/board/models/board_piece.gd")


func clear_positions_and_refill(board_state: BoardState, positions: Array, spawned_specials: Dictionary = {}) -> Dictionary:
    var cleared_positions: Array = _collect_unique_positions_from_positions(positions)
    var color_counts: Dictionary = {}

    for position in cleared_positions:
        var removed_piece: Variant = board_state.get_piece(position.y, position.x)
        if removed_piece != null:
            var color_key := String(removed_piece.color_id)
            color_counts[color_key] = int(color_counts.get(color_key, 0)) + 1

        board_state.set_piece(position.y, position.x, null)

    for raw_position in spawned_specials.keys():
        var position: Vector2i = raw_position
        var special_data: Dictionary = spawned_specials[raw_position]
        board_state.set_piece(
            position.y,
            position.x,
            BoardPiece.new(
                String(special_data.get("color_id", "yellow")),
                String(special_data.get("special_type", BoardPiece.SPECIAL_NONE))
            )
        )

    for column in range(board_state.width):
        _collapse_column(board_state, column)

    return {
        "positions": cleared_positions,
        "color_counts": color_counts
    }


func _collect_unique_positions_from_matches(matches: Array) -> Array:
    var unique_positions: Dictionary = {}

    for match_data in matches:
        for position in match_data.get("cells", []):
            unique_positions[position] = true

    return unique_positions.keys()


func _collect_unique_positions_from_positions(positions: Array) -> Array:
    var unique_positions: Dictionary = {}

    for raw_position in positions:
        if raw_position is Vector2i:
            var position: Vector2i = raw_position
            unique_positions[position] = true

    return unique_positions.keys()


func _collapse_column(board_state: BoardState, column: int) -> void:
    var fillable_rows: Array = board_state.get_fillable_rows_for_column(column)
    if fillable_rows.is_empty():
        return

    var surviving_pieces: Array = []

    for index in range(fillable_rows.size() - 1, -1, -1):
        var row = fillable_rows[index]
        var piece: Variant = board_state.get_piece(row, column)
        if piece != null:
            surviving_pieces.append(piece)

    var write_index: int = 0

    for index in range(fillable_rows.size() - 1, -1, -1):
        var row = fillable_rows[index]
        if write_index < surviving_pieces.size():
            board_state.set_piece(row, column, surviving_pieces[write_index])
            write_index += 1
        else:
            board_state.set_piece(row, column, BoardPiece.new(board_state.draw_random_color()))
