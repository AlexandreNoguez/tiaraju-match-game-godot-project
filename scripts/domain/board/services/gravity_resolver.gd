extends RefCounted
class_name GravityResolver

const BoardPiece = preload("res://scripts/domain/board/models/board_piece.gd")


func clear_matches_and_refill(board_state: BoardState, matches: Array) -> Array:
    var cleared_positions := _collect_unique_positions(matches)

    for position in cleared_positions:
        board_state.set_piece(position.y, position.x, null)

    for column in range(board_state.width):
        _collapse_column(board_state, column)

    return cleared_positions


func _collect_unique_positions(matches: Array) -> Array:
    var unique_positions := {}

    for match_data in matches:
        for position in match_data.get("cells", []):
            unique_positions[position] = true

    return unique_positions.keys()


func _collapse_column(board_state: BoardState, column: int) -> void:
    var playable_rows := board_state.get_playable_rows_for_column(column)
    if playable_rows.is_empty():
        return

    var surviving_pieces := []

    for index in range(playable_rows.size() - 1, -1, -1):
        var row = playable_rows[index]
        var piece = board_state.get_piece(row, column)
        if piece != null:
            surviving_pieces.append(piece)

    var write_index := 0

    for index in range(playable_rows.size() - 1, -1, -1):
        var row = playable_rows[index]
        if write_index < surviving_pieces.size():
            board_state.set_piece(row, column, surviving_pieces[write_index])
            write_index += 1
        else:
            board_state.set_piece(row, column, BoardPiece.new(board_state.draw_random_color()))
