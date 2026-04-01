extends Node

const StartLevelUseCase = preload("res://scripts/application/use_cases/start_level_use_case.gd")
const BoardGenerator = preload("res://scripts/domain/board/services/board_generator.gd")
const LevelRepository = preload("res://scripts/infrastructure/levels/level_repository.gd")
const BoardScreenScene = preload("res://scenes/presentation/board/board_screen.tscn")


func _ready() -> void:
    var repository: LevelRepository = LevelRepository.new()
    var generator: BoardGenerator = BoardGenerator.new()
    var start_level: StartLevelUseCase = StartLevelUseCase.new(repository, generator)
    var payload: Dictionary = start_level.execute("level_001")

    if payload.is_empty():
        push_error("Failed to bootstrap the initial level.")
        return

    var board_screen := BoardScreenScene.instantiate() as BoardScreen
    if board_screen == null:
        push_error("Failed to instantiate the board screen.")
        return

    board_screen.setup(payload["level_data"], payload["session_state"])
    add_child(board_screen)
