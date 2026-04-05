extends RefCounted
class_name BoardState

var width: int
var height: int
var playable_cells: Array[BoardCell]
var allowed_colors: Array[String]
var pieces: Array = []
var random_generator: RandomNumberGenerator


func _init(
	board_width: int,
	board_height: int,
	cells: Array[BoardCell] = [],
	colors: Array[String] = [],
	seed: int = 0
) -> void:
	width = board_width
	height = board_height
	playable_cells = cells.duplicate()
	allowed_colors = colors.duplicate()
	random_generator = RandomNumberGenerator.new()

	if seed == 0:
		random_generator.randomize()
	else:
		random_generator.seed = seed

	for _row in range(height):
		var row_data: Array = []
		row_data.resize(width)
		pieces.append(row_data)


func has_cell(row: int, column: int) -> bool:
	var cell: BoardCell = get_cell(row, column)
	if cell != null and cell.is_playable:
		return true

	return false


func get_cell(row: int, column: int) -> BoardCell:
	for cell in playable_cells:
		if cell.row == row and cell.column == column:
			return cell

	return null


func can_hold_piece(row: int, column: int) -> bool:
	var cell: BoardCell = get_cell(row, column)
	return cell != null and cell.can_hold_piece()


func is_inside(row: int, column: int) -> bool:
	return row >= 0 and row < height and column >= 0 and column < width


func get_piece(row: int, column: int):
	if not is_inside(row, column):
		return null

	return pieces[row][column]


func set_piece(row: int, column: int, piece) -> void:
	if not is_inside(row, column):
		return

	pieces[row][column] = piece


func swap_pieces(first_position: Vector2i, second_position: Vector2i) -> void:
	var first_row: int = first_position.y
	var first_column: int = first_position.x
	var second_row: int = second_position.y
	var second_column: int = second_position.x

	var first_piece: Variant = get_piece(first_row, first_column)
	var second_piece: Variant = get_piece(second_row, second_column)

	set_piece(first_row, first_column, second_piece)
	set_piece(second_row, second_column, first_piece)


func get_fillable_rows_for_column(column: int) -> Array:
	var rows: Array[int] = []

	for row in range(height):
		if can_hold_piece(row, column):
			rows.append(row)

	return rows


func get_playable_positions() -> Array:
	var positions: Array[Vector2i] = []

	for row in range(height):
		for column in range(width):
			if has_cell(row, column):
				positions.append(Vector2i(column, row))

	return positions


func get_playable_bounds() -> Rect2i:
	if playable_cells.is_empty():
		return Rect2i(0, 0, 0, 0)

	var min_row: int = height
	var max_row: int = -1
	var min_column: int = width
	var max_column: int = -1

	for cell in playable_cells:
		if not cell.is_playable:
			continue

		min_row = min(min_row, cell.row)
		max_row = max(max_row, cell.row)
		min_column = min(min_column, cell.column)
		max_column = max(max_column, cell.column)

	if max_row < min_row or max_column < min_column:
		return Rect2i(0, 0, 0, 0)

	return Rect2i(
		min_column,
		min_row,
		(max_column - min_column) + 1,
		(max_row - min_row) + 1
	)


func draw_random_color() -> String:
	if allowed_colors.is_empty():
		return "yellow"

	var random_index: int = random_generator.randi_range(0, allowed_colors.size() - 1)
	return allowed_colors[random_index]


func duplicate_state() -> BoardState:
	var duplicated_cells: Array[BoardCell] = []
	for cell in playable_cells:
		duplicated_cells.append(cell.duplicate_cell())

	var duplicated_state := BoardState.new(width, height, duplicated_cells, allowed_colors, 1)
	for row in range(height):
		for column in range(width):
			var piece = get_piece(row, column)
			if piece != null:
				duplicated_state.set_piece(row, column, piece.duplicate_piece())

	return duplicated_state
