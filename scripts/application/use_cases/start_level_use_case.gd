extends RefCounted
class_name StartLevelUseCase

var _level_repository: LevelRepository


func _init(level_repository: LevelRepository) -> void:
    _level_repository = level_repository


func execute(level_id: String) -> Dictionary:
    return _level_repository.fetch_by_id(level_id)
