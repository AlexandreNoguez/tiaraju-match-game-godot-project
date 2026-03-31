extends RefCounted
class_name BoardPiece

var color_id: String
var special_type: String


func _init(piece_color_id: String, piece_special_type: String = "") -> void:
    color_id = piece_color_id
    special_type = piece_special_type


func is_special() -> bool:
    return special_type != ""
