extends RefCounted
class_name BoardState

var width: int
var height: int
var playable_cells: Array[BoardCell]


func _init(board_width: int, board_height: int, cells: Array[BoardCell] = []) -> void:
    width = board_width
    height = board_height
    playable_cells = cells


func has_cell(row: int, column: int) -> bool:
    for cell in playable_cells:
        if cell.row == row and cell.column == column and cell.is_playable:
            return true

    return false
