extends Node

const BoardGenerator = preload("res://scripts/domain/board/services/board_generator.gd")
const BoardScreenScene = preload("res://scenes/presentation/board/board_screen.tscn")
const LevelProgressUseCase = preload("res://scripts/application/use_cases/level_progress_use_case.gd")
const LevelRepository = preload("res://scripts/infrastructure/levels/level_repository.gd")
const LocalSaveGateway = preload("res://scripts/infrastructure/persistence/local_save_gateway.gd")
const StartLevelUseCase = preload("res://scripts/application/use_cases/start_level_use_case.gd")

const DEFAULT_LEVEL_ID := "level_001"


func _ready() -> void:
    var repository: LevelRepository = LevelRepository.new()
    var generator: BoardGenerator = BoardGenerator.new()
    var save_gateway: LocalSaveGateway = LocalSaveGateway.new()
    var progress_use_case: LevelProgressUseCase = LevelProgressUseCase.new(save_gateway)
    var start_level: StartLevelUseCase = StartLevelUseCase.new(repository, generator)
    var initial_level_id: String = progress_use_case.load_start_level_id(DEFAULT_LEVEL_ID)
    var payload: Dictionary = start_level.execute(initial_level_id)

    if payload.is_empty() and initial_level_id != DEFAULT_LEVEL_ID:
        initial_level_id = DEFAULT_LEVEL_ID
        payload = start_level.execute(initial_level_id)

    if payload.is_empty():
        push_error("Failed to bootstrap the initial level.")
        return

    progress_use_case.record_opened_level(initial_level_id)

    var board_screen := BoardScreenScene.instantiate() as BoardScreen
    if board_screen == null:
        push_error("Failed to instantiate the board screen.")
        return

    board_screen.setup(payload["level_data"], payload["session_state"])
    add_child(board_screen)
