extends RefCounted
class_name BoardCell

const OBSTACLE_NONE := ""
const OBSTACLE_BOX := "box"
const OBSTACLE_ICE := "ice"

var row: int
var column: int
var is_playable: bool
var obstacle_type: String
var obstacle_hits_remaining: int


func _init(
    cell_row: int,
    cell_column: int,
    playable: bool = true,
    cell_obstacle_type: String = "",
    cell_obstacle_hits_remaining: int = 0
) -> void:
    row = cell_row
    column = cell_column
    is_playable = playable
    obstacle_type = cell_obstacle_type
    obstacle_hits_remaining = cell_obstacle_hits_remaining


func has_obstacle() -> bool:
    return obstacle_type != OBSTACLE_NONE and obstacle_hits_remaining > 0


func can_hold_piece() -> bool:
    return is_playable and not blocks_piece_spawn()


func blocks_piece_spawn() -> bool:
    return obstacle_type == OBSTACLE_BOX and obstacle_hits_remaining > 0


func damage() -> bool:
    if not has_obstacle():
        return false

    obstacle_hits_remaining = max(0, obstacle_hits_remaining - 1)
    if obstacle_hits_remaining == 0:
        obstacle_type = OBSTACLE_NONE
        return true

    return false
