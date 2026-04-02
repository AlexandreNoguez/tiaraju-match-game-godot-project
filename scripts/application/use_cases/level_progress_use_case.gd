extends RefCounted
class_name LevelProgressUseCase

var _save_gateway: LocalSaveGateway


func _init(save_gateway: LocalSaveGateway) -> void:
    _save_gateway = save_gateway


func load_start_level_id(default_level_id: String) -> String:
    var payload: Dictionary = _save_gateway.load_progress()
    var level_id: String = String(payload.get("last_opened_level_id", default_level_id))
    if level_id == "":
        return default_level_id

    return level_id


func record_opened_level(level_id: String) -> void:
    var payload: Dictionary = _save_gateway.load_progress()
    payload["last_opened_level_id"] = level_id

    if String(payload.get("highest_unlocked_level_id", "")) == "":
        payload["highest_unlocked_level_id"] = level_id

    _save_gateway.save_progress(payload)


func record_victory(level_id: String, next_level_id: String) -> void:
    var payload: Dictionary = _save_gateway.load_progress()
    var completed_levels: Array = payload.get("completed_levels", [])
    if not completed_levels.has(level_id):
        completed_levels.append(level_id)

    payload["completed_levels"] = completed_levels
    payload["last_completed_level_id"] = level_id
    payload["last_opened_level_id"] = next_level_id if next_level_id != "" else level_id

    var highest_unlocked_level_id: String = String(payload.get("highest_unlocked_level_id", level_id))
    if next_level_id != "" and _level_number(next_level_id) > _level_number(highest_unlocked_level_id):
        highest_unlocked_level_id = next_level_id

    payload["highest_unlocked_level_id"] = highest_unlocked_level_id
    _save_gateway.save_progress(payload)


func _level_number(level_id: String) -> int:
    if not level_id.begins_with("level_"):
        return 0

    var numeric_part: String = level_id.trim_prefix("level_")
    if not numeric_part.is_valid_int():
        return 0

    return int(numeric_part)
