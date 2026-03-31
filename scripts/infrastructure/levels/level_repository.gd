extends RefCounted
class_name LevelRepository

const LEVEL_PATH_TEMPLATE := "res://data/levels/%s.json"


func fetch_by_id(level_id: String) -> Dictionary:
    var level_path := LEVEL_PATH_TEMPLATE % level_id

    if not FileAccess.file_exists(level_path):
        push_warning("Level file not found: %s" % level_path)
        return {}

    var file := FileAccess.open(level_path, FileAccess.READ)
    if file == null:
        push_warning("Failed to open level file: %s" % level_path)
        return {}

    var parsed := JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        return parsed

    push_warning("Invalid level JSON: %s" % level_path)
    return {}
