extends RefCounted
class_name BoardGenerator

const BoardCell = preload("res://scripts/domain/board/models/board_cell.gd")
const BoardPiece = preload("res://scripts/domain/board/models/board_piece.gd")
const BoardState = preload("res://scripts/domain/board/models/board_state.gd")


func generate_from_level(level_data: Dictionary) -> BoardState:
    var grid_mask: Array = level_data.get("grid_mask", [])
    var board_height := grid_mask.size()
    var board_width := 0
    var playable_cells: Array[BoardCell] = []
    var allowed_colors: Array[String] = []

    if board_height > 0:
        board_width = grid_mask[0].size()

    for color_value in level_data.get("allowed_colors", []):
        allowed_colors.append(String(color_value))

    for row in range(board_height):
        for column in range(board_width):
            if int(grid_mask[row][column]) == 1:
                playable_cells.append(BoardCell.new(row, column, true))

    var board_state := BoardState.new(
        board_width,
        board_height,
        playable_cells,
        allowed_colors,
        int(level_data.get("seed", 0))
    )

    for row in range(board_height):
        for column in range(board_width):
            if not board_state.has_cell(row, column):
                continue

            var color_id := _pick_color_without_initial_match(board_state, row, column)
            board_state.set_piece(row, column, BoardPiece.new(color_id))

    return board_state


func _pick_color_without_initial_match(board_state: BoardState, row: int, column: int) -> String:
    if board_state.allowed_colors.is_empty():
        return "yellow"

    var start_index := board_state.random_generator.randi_range(0, board_state.allowed_colors.size() - 1)

    for offset in range(board_state.allowed_colors.size()):
        var color_id: String = board_state.allowed_colors[(start_index + offset) % board_state.allowed_colors.size()]
        if not _would_create_initial_match(board_state, row, column, color_id):
            return color_id

    return board_state.allowed_colors[start_index]


func _would_create_initial_match(board_state: BoardState, row: int, column: int, color_id: String) -> bool:
    var left_one = board_state.get_piece(row, column - 1)
    var left_two = board_state.get_piece(row, column - 2)
    if left_one != null and left_two != null and left_one.color_id == color_id and left_two.color_id == color_id:
        return true

    var up_one = board_state.get_piece(row - 1, column)
    var up_two = board_state.get_piece(row - 2, column)
    if up_one != null and up_two != null and up_one.color_id == color_id and up_two.color_id == color_id:
        return true

    return false
