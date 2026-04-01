extends RefCounted
class_name BoardPiece

const SPECIAL_NONE := ""
const SPECIAL_MISSILE_HORIZONTAL := "missile_horizontal"
const SPECIAL_MISSILE_VERTICAL := "missile_vertical"
const SPECIAL_RAINBOW := "rainbow"

var color_id: String
var special_type: String


func _init(piece_color_id: String, piece_special_type: String = "") -> void:
    color_id = piece_color_id
    special_type = piece_special_type


func is_special() -> bool:
    return special_type != ""


func is_missile() -> bool:
    return special_type == SPECIAL_MISSILE_HORIZONTAL or special_type == SPECIAL_MISSILE_VERTICAL


func is_rainbow() -> bool:
    return special_type == SPECIAL_RAINBOW
