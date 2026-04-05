extends Node

const BoardGenerator = preload("res://scripts/domain/board/services/board_generator.gd")
const BoardScreenScene = preload("res://scenes/presentation/board/board_screen.tscn")
const MainMenuScreenScene = preload("res://scenes/presentation/main_menu/main_menu_screen.tscn")
const LevelProgressUseCase = preload("res://scripts/application/use_cases/level_progress_use_case.gd")
const LevelRepository = preload("res://scripts/infrastructure/levels/level_repository.gd")
const LocalSaveGateway = preload("res://scripts/infrastructure/persistence/local_save_gateway.gd")
const StartLevelUseCase = preload("res://scripts/application/use_cases/start_level_use_case.gd")

const DEFAULT_LEVEL_ID := "level_001"

var _repository: LevelRepository
var _generator: BoardGenerator
var _save_gateway: LocalSaveGateway
var _progress_use_case: LevelProgressUseCase
var _start_level_use_case: StartLevelUseCase
var _active_screen: Node


func _ready() -> void:
	_initialize_services()
	_show_main_menu()


func _initialize_services() -> void:
	_repository = LevelRepository.new()
	_generator = BoardGenerator.new()
	_save_gateway = LocalSaveGateway.new()
	_progress_use_case = LevelProgressUseCase.new(_save_gateway)
	_start_level_use_case = StartLevelUseCase.new(_repository, _generator)


func _show_main_menu() -> void:
	var level_id: String = _resolve_existing_level_id(_progress_use_case.load_start_level_id(DEFAULT_LEVEL_ID))
	var level_data: Dictionary = _repository.fetch_by_id(level_id)
	if level_data.is_empty():
		push_error("Failed to bootstrap the main menu.")
		return

	var main_menu = MainMenuScreenScene.instantiate()
	if main_menu == null:
		push_error("Failed to instantiate the main menu screen.")
		return

	main_menu.setup(
		level_data,
		_progress_use_case.load_progress_payload(),
		{
			"enabled": OS.is_debug_build(),
			"level_ids": _repository.list_level_ids(),
			"selected_level_id": level_id
		}
	)
	main_menu.play_requested.connect(_on_play_requested)
	main_menu.playtest_level_requested.connect(_on_playtest_level_requested)
	main_menu.reset_save_requested.connect(_on_reset_save_requested)
	_replace_active_screen(main_menu)


func _on_play_requested(level_id: String) -> void:
	_open_level(level_id)


func _on_playtest_level_requested(level_id: String) -> void:
	_open_level(level_id, true)


func _on_reset_save_requested() -> void:
	var reset_result: Error = _save_gateway.clear_progress()
	if reset_result != OK:
		push_error("Failed to clear local save data.")
		return

	_show_main_menu()


func _open_level(level_id: String, playtest_mode: bool = false) -> void:
	var resolved_level_id: String = _resolve_existing_level_id(level_id)
	var payload: Dictionary = _start_level_use_case.execute(resolved_level_id)

	if payload.is_empty():
		push_error("Failed to load level: %s" % resolved_level_id)
		return

	if not playtest_mode:
		_progress_use_case.record_opened_level(resolved_level_id)

	var board_screen := BoardScreenScene.instantiate() as BoardScreen
	if board_screen == null:
		push_error("Failed to instantiate the board screen.")
		return

	board_screen.setup(payload["level_data"], payload["session_state"], {"playtest_mode": playtest_mode})
	board_screen.home_requested.connect(_show_main_menu)
	_replace_active_screen(board_screen)


func _replace_active_screen(screen: Node) -> void:
	if _active_screen != null and is_instance_valid(_active_screen):
		_active_screen.queue_free()

	_active_screen = screen
	add_child(_active_screen)


func _resolve_existing_level_id(level_id: String) -> String:
	var resolved_level_id: String = level_id if level_id != "" else DEFAULT_LEVEL_ID
	if _repository.fetch_by_id(resolved_level_id).is_empty():
		return DEFAULT_LEVEL_ID

	return resolved_level_id
