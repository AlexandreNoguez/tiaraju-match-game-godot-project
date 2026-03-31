extends Node

const StartLevelUseCase = preload("res://scripts/application/use_cases/start_level_use_case.gd")
const BoardGenerator = preload("res://scripts/domain/board/services/board_generator.gd")
const LevelRepository = preload("res://scripts/infrastructure/levels/level_repository.gd")
const BoardScreenScene = preload("res://scenes/presentation/board/board_screen.tscn")


func _ready() -> void:
    var repository := LevelRepository.new()
    var generator := BoardGenerator.new()
    var start_level := StartLevelUseCase.new(repository, generator)
    var payload := start_level.execute("level_001")

    if payload.is_empty():
        push_error("Failed to bootstrap the initial level.")
        return

    var board_screen = BoardScreenScene.instantiate()
    board_screen.setup(payload["level_data"], payload["session_state"])
    add_child(board_screen)
