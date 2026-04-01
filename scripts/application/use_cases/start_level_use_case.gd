extends RefCounted
class_name StartLevelUseCase

var _level_repository: LevelRepository
var _board_generator: BoardGenerator


func _init(level_repository: LevelRepository, board_generator: BoardGenerator) -> void:
    _level_repository = level_repository
    _board_generator = board_generator


func execute(level_id: String) -> Dictionary:
    var level_data: Dictionary = _level_repository.fetch_by_id(level_id)
    if level_data.is_empty():
        return {}

    var board_state: BoardState = _board_generator.generate_from_level(level_data)
    var session_state: LevelSessionState = LevelSessionState.new(level_data, board_state)

    return {
        "level_data": level_data,
        "session_state": session_state
    }
