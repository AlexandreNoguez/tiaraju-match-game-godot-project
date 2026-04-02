extends RefCounted
class_name LevelRepository

const LEVEL_PATH_TEMPLATE := "res://data/levels/%s.json"


func fetch_by_id(level_id: String) -> Dictionary:
    var level_path: String = LEVEL_PATH_TEMPLATE % level_id

    if not FileAccess.file_exists(level_path):
        push_warning("Level file not found: %s" % level_path)
        return {}

    var file: FileAccess = FileAccess.open(level_path, FileAccess.READ)
    if file == null:
        push_warning("Failed to open level file: %s" % level_path)
        return {}

    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        return parsed

    push_warning("Invalid level JSON: %s" % level_path)
    return {}


func list_level_ids() -> Array[String]:
    var directory := DirAccess.open("res://data/levels")
    var level_ids: Array[String] = []
    if directory == null:
        push_warning("Failed to open level directory: res://data/levels")
        return level_ids

    directory.list_dir_begin()
    while true:
        var file_name := directory.get_next()
        if file_name == "":
            break
        if directory.current_is_dir():
            continue
        if not file_name.ends_with(".json"):
            continue

        level_ids.append(file_name.trim_suffix(".json"))

    directory.list_dir_end()
    level_ids.sort()
    return level_ids
