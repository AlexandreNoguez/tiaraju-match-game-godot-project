extends RefCounted
class_name BoardPiece

const SPECIAL_NONE := ""
const SPECIAL_MISSILE_HORIZONTAL := "missile_horizontal"
const SPECIAL_MISSILE_VERTICAL := "missile_vertical"
const SPECIAL_RAINBOW := "rainbow"

static var _next_uid: int = 1

var color_id: String
var special_type: String
var uid: int


func _init(piece_color_id: String, piece_special_type: String = "", piece_uid: int = 0) -> void:
    color_id = piece_color_id
    special_type = piece_special_type
    if piece_uid > 0:
        uid = piece_uid
        _next_uid = max(_next_uid, piece_uid + 1)
    else:
        uid = _next_uid
        _next_uid += 1


func is_special() -> bool:
    return special_type != ""


func is_missile() -> bool:
    return special_type == SPECIAL_MISSILE_HORIZONTAL or special_type == SPECIAL_MISSILE_VERTICAL


func is_rainbow() -> bool:
    return special_type == SPECIAL_RAINBOW


func duplicate_piece() -> BoardPiece:
    return BoardPiece.new(color_id, special_type, uid)
