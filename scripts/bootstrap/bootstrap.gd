extends Node

const StartLevelUseCase = preload("res://scripts/application/use_cases/start_level_use_case.gd")
const LevelRepository = preload("res://scripts/infrastructure/levels/level_repository.gd")


func _ready() -> void:
    var repository := LevelRepository.new()
    var start_level := StartLevelUseCase.new(repository)
    var level_data := start_level.execute("level_001")

    print("Bootstrap ready.")
    print("Loaded level id: %s" % level_data.get("id", "missing"))
