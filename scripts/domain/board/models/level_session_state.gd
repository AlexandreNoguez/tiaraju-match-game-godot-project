extends RefCounted
class_name LevelSessionState

var board_state: BoardState
var level_id: String
var level_name: String
var moves_remaining: int
var goals: Array[Dictionary]
var status: String


func _init(level_data: Dictionary, initial_board_state: BoardState) -> void:
    board_state = initial_board_state
    level_id = String(level_data.get("id", ""))
    level_name = String(level_data.get("name", "Fase"))
    moves_remaining = int(level_data.get("moves", 0))
    status = "playing"
    goals = []

    for raw_goal in level_data.get("goals", []):
        goals.append(
            {
                "type": String(raw_goal.get("type", "")),
                "color": String(raw_goal.get("color", "")),
                "target_amount": int(raw_goal.get("amount", 0)),
                "current_amount": 0
            }
        )


func can_accept_input() -> bool:
    return status == "playing"


func consume_move() -> void:
    moves_remaining = max(0, moves_remaining - 1)


func register_removed_colors(color_counts: Dictionary) -> void:
    for goal in goals:
        if goal.get("type", "") != "collect_color":
            continue

        var color_key := goal.get("color", "")
        var current_amount := int(goal.get("current_amount", 0))
        var target_amount := int(goal.get("target_amount", 0))
        var removed_amount := int(color_counts.get(color_key, 0))

        goal["current_amount"] = min(target_amount, current_amount + removed_amount)


func update_status_after_turn() -> void:
    if are_goals_completed():
        status = "victory"
        return

    if moves_remaining <= 0:
        status = "defeat"
        return

    status = "playing"


func are_goals_completed() -> bool:
    if goals.is_empty():
        return false

    for goal in goals:
        if int(goal.get("current_amount", 0)) < int(goal.get("target_amount", 0)):
            return false

    return true
