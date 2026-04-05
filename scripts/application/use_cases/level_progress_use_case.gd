extends RefCounted
class_name LevelProgressUseCase

var _save_gateway: LocalSaveGateway


func _init(save_gateway: LocalSaveGateway) -> void:
    _save_gateway = save_gateway


func load_start_level_id(default_level_id: String) -> String:
    var payload: Dictionary = load_progress_payload()
    var level_id: String = String(payload.get("highest_unlocked_level_id", ""))
    if level_id == "":
        level_id = String(payload.get("last_opened_level_id", default_level_id))

    if level_id == "":
        return default_level_id

    return level_id


func load_progress_payload() -> Dictionary:
    var payload: Dictionary = _save_gateway.load_progress()
    var normalized_payload: Dictionary = payload.duplicate(true)

    if normalized_payload.get("completed_levels", null) is not Array:
        normalized_payload["completed_levels"] = []

    normalized_payload["coins"] = int(normalized_payload.get("coins", 0))
    normalized_payload["last_opened_level_id"] = String(normalized_payload.get("last_opened_level_id", ""))
    normalized_payload["last_completed_level_id"] = String(normalized_payload.get("last_completed_level_id", ""))
    normalized_payload["highest_unlocked_level_id"] = String(normalized_payload.get("highest_unlocked_level_id", ""))
    normalized_payload["music_enabled"] = bool(normalized_payload.get("music_enabled", true))
    normalized_payload["sfx_enabled"] = bool(normalized_payload.get("sfx_enabled", true))

    return normalized_payload


func record_opened_level(level_id: String) -> void:
    var payload: Dictionary = load_progress_payload()
    payload["last_opened_level_id"] = level_id

    if String(payload.get("highest_unlocked_level_id", "")) == "":
        payload["highest_unlocked_level_id"] = level_id

    _save_gateway.save_progress(payload)


func record_victory(level_id: String, next_level_id: String) -> void:
    var payload: Dictionary = load_progress_payload()
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


func award_coins(amount: int) -> void:
    if amount <= 0:
        return

    var payload: Dictionary = load_progress_payload()
    payload["coins"] = int(payload.get("coins", 0)) + amount
    _save_gateway.save_progress(payload)


func save_audio_settings(music_enabled: bool, sfx_enabled: bool) -> void:
    var payload: Dictionary = load_progress_payload()
    payload["music_enabled"] = music_enabled
    payload["sfx_enabled"] = sfx_enabled
    _save_gateway.save_progress(payload)


func _level_number(level_id: String) -> int:
    if not level_id.begins_with("level_"):
        return 0

    var numeric_part: String = level_id.trim_prefix("level_")
    if not numeric_part.is_valid_int():
        return 0

    return int(numeric_part)
