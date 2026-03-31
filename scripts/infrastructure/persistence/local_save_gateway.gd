extends RefCounted
class_name LocalSaveGateway

const SAVE_PATH := "user://save_game.json"


func save_progress(payload: Dictionary) -> Error:
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file == null:
        return ERR_CANT_OPEN

    file.store_string(JSON.stringify(payload))
    return OK


func load_progress() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        return {}

    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        return {}

    var parsed := JSON.parse_string(file.get_as_text())
    return parsed if parsed is Dictionary else {}
