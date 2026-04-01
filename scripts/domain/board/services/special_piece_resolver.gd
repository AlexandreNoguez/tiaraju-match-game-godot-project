extends RefCounted
class_name SpecialPieceResolver

const BoardPiece = preload("res://scripts/domain/board/models/board_piece.gd")


func build_spawned_specials(matches: Array, primary_positions: Array[Vector2i]) -> Dictionary:
    var spawned_specials: Dictionary = {}

    for match_data in matches:
        var match_size: int = int(match_data.get("size", 0))
        if match_size < 4:
            continue

        var cells: Array = match_data.get("cells", [])
        var orientation: String = String(match_data.get("orientation", ""))
        var spawn_position: Vector2i = _pick_spawn_position(cells, primary_positions)
        var special_type: String = _special_type_for_match(match_size, orientation)
        if special_type == BoardPiece.SPECIAL_NONE:
            continue

        var color_id: String = String(match_data.get("color_id", "yellow"))
        spawned_specials[spawn_position] = {
            "color_id": color_id,
            "special_type": special_type
        }
    return spawned_specials


func build_swap_special_activation(board_state: BoardState, first_position: Vector2i, second_position: Vector2i) -> Dictionary:
    var first_piece: Variant = board_state.get_piece(first_position.y, first_position.x)
    var second_piece: Variant = board_state.get_piece(second_position.y, second_position.x)
    if first_piece == null or second_piece == null:
        return {}

    if first_piece.is_rainbow() and second_piece.is_rainbow():
        return {
            "positions": board_state.get_playable_positions(),
            "message": "Combo de coringas! O tabuleiro inteiro foi limpo."
        }

    if first_piece.is_rainbow():
        return {
            "positions": _all_positions_by_color(board_state, second_piece.color_id, [first_position]),
            "message": "Coringa ativado! Todas as pecas %s foram removidas." % second_piece.color_id
        }

    if second_piece.is_rainbow():
        return {
            "positions": _all_positions_by_color(board_state, first_piece.color_id, [second_position]),
            "message": "Coringa ativado! Todas as pecas %s foram removidas." % first_piece.color_id
        }

    if first_piece.is_missile() and second_piece.is_missile():
        var combo_positions: Array = []
        combo_positions.append_array(_positions_for_piece_activation(board_state, first_position, first_piece))
        combo_positions.append_array(_positions_for_piece_activation(board_state, second_position, second_piece))
        combo_positions.append(first_position)
        combo_positions.append(second_position)
        return {
            "positions": _unique_positions(combo_positions),
            "message": "Combo de misseis ativado!"
        }

    if first_piece.is_missile():
        return {
            "positions": _unique_positions(_positions_for_piece_activation(board_state, first_position, first_piece) + [second_position]),
            "message": "Missil ativado!"
        }

    if second_piece.is_missile():
        return {
            "positions": _unique_positions(_positions_for_piece_activation(board_state, second_position, second_piece) + [first_position]),
            "message": "Missil ativado!"
        }

    return {}


func expand_positions_with_specials(board_state: BoardState, positions: Array) -> Array:
    var visited: Dictionary = {}
    var queue: Array[Vector2i] = []

    for position in positions:
        if position is Vector2i:
            var typed_position: Vector2i = position
            if not visited.has(typed_position):
                visited[typed_position] = true
                queue.append(typed_position)

    var index: int = 0
    while index < queue.size():
        var position: Vector2i = queue[index]
        index += 1

        var piece: Variant = board_state.get_piece(position.y, position.x)
        if piece == null or not piece.is_special():
            continue

        for extra_position in _positions_for_piece_activation(board_state, position, piece):
            if not visited.has(extra_position):
                visited[extra_position] = true
                queue.append(extra_position)

    return queue


func _pick_spawn_position(cells: Array, primary_positions: Array[Vector2i]) -> Vector2i:
    for primary_position in primary_positions:
        if cells.has(primary_position):
            return primary_position

    if not cells.is_empty():
        return cells[cells.size() - 1]

    return Vector2i.ZERO


func _special_type_for_match(match_size: int, orientation: String) -> String:
    if match_size >= 5:
        return BoardPiece.SPECIAL_RAINBOW

    if match_size == 4:
        if orientation == "horizontal":
            return BoardPiece.SPECIAL_MISSILE_HORIZONTAL
        if orientation == "vertical":
            return BoardPiece.SPECIAL_MISSILE_VERTICAL

    return BoardPiece.SPECIAL_NONE


func _positions_for_piece_activation(board_state: BoardState, position: Vector2i, piece: BoardPiece) -> Array[Vector2i]:
    if piece.special_type == BoardPiece.SPECIAL_MISSILE_HORIZONTAL:
        return _positions_for_row(board_state, position.y)

    if piece.special_type == BoardPiece.SPECIAL_MISSILE_VERTICAL:
        return _positions_for_column(board_state, position.x)

    if piece.special_type == BoardPiece.SPECIAL_RAINBOW:
        return _all_positions_by_color(board_state, piece.color_id, [position])

    return []


func _positions_for_row(board_state: BoardState, row: int) -> Array[Vector2i]:
    var positions: Array[Vector2i] = []
    for column in range(board_state.width):
        if board_state.has_cell(row, column):
            positions.append(Vector2i(column, row))
    return positions


func _positions_for_column(board_state: BoardState, column: int) -> Array[Vector2i]:
    var positions: Array[Vector2i] = []
    for row in range(board_state.height):
        if board_state.has_cell(row, column):
            positions.append(Vector2i(column, row))
    return positions


func _all_positions_by_color(board_state: BoardState, color_id: String, extra_positions: Array[Vector2i] = []) -> Array[Vector2i]:
    var positions: Array[Vector2i] = []
    for position in board_state.get_playable_positions():
        var piece: Variant = board_state.get_piece(position.y, position.x)
        if piece != null and piece.color_id == color_id:
            positions.append(position)

    positions.append_array(extra_positions)
    return _unique_positions(positions)


func _unique_positions(positions: Array) -> Array[Vector2i]:
    var seen: Dictionary = {}
    var unique_positions: Array[Vector2i] = []

    for raw_position in positions:
        if raw_position is Vector2i:
            var position: Vector2i = raw_position
            if not seen.has(position):
                seen[position] = true
                unique_positions.append(position)

    return unique_positions
