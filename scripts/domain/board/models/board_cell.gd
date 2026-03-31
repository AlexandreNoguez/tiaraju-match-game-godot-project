extends RefCounted
class_name BoardCell

var row: int
var column: int
var is_playable: bool


func _init(cell_row: int, cell_column: int, playable: bool = true) -> void:
    row = cell_row
    column = cell_column
    is_playable = playable
