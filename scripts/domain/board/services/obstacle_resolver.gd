extends RefCounted
class_name ObstacleResolver

const BoardCell = preload("res://scripts/domain/board/models/board_cell.gd")

const ORTHOGONAL_DIRECTIONS: Array[Vector2i] = [
    Vector2i(1, 0),
    Vector2i(-1, 0),
    Vector2i(0, 1),
    Vector2i(0, -1)
]


func apply_damage(board_state: BoardState, direct_positions: Array, adjacent_damage_sources: Array = []) -> Dictionary:
    var affected_positions: Array[Vector2i] = _collect_affected_positions(
        board_state,
        direct_positions,
        adjacent_damage_sources
    )
    var direct_position_lookup: Dictionary = _build_position_lookup(direct_positions)
    var adjacent_position_lookup: Dictionary = _build_adjacent_lookup(board_state, adjacent_damage_sources)
    var removed_counts: Dictionary = {}
    var removed_positions: Array[Vector2i] = []

    for position in affected_positions:
        var cell: BoardCell = board_state.get_cell(position.y, position.x)
        if cell == null or not cell.has_obstacle():
            continue

        if not _should_damage_cell(cell, position, direct_position_lookup, adjacent_position_lookup):
            continue

        var obstacle_type: String = cell.obstacle_type
        var was_removed: bool = cell.damage()
        if was_removed:
            removed_counts[obstacle_type] = int(removed_counts.get(obstacle_type, 0)) + 1
            removed_positions.append(position)
            board_state.set_piece(position.y, position.x, null)

    return {
        "removed_counts": removed_counts,
        "removed_positions": removed_positions
    }


func _collect_affected_positions(
    board_state: BoardState,
    direct_positions: Array,
    adjacent_damage_sources: Array
) -> Array[Vector2i]:
    var unique_positions: Dictionary = {}

    for raw_position in direct_positions:
        if raw_position is not Vector2i:
            continue

        var position: Vector2i = raw_position
        _mark_if_valid(board_state, unique_positions, position)

    for raw_position in adjacent_damage_sources:
        if raw_position is not Vector2i:
            continue

        var adjacent_source: Vector2i = raw_position
        for direction in ORTHOGONAL_DIRECTIONS:
            _mark_if_valid(board_state, unique_positions, adjacent_source + direction)

    var affected_positions: Array[Vector2i] = []
    for raw_position in unique_positions.keys():
        if raw_position is Vector2i:
            affected_positions.append(raw_position)

    return affected_positions


func _mark_if_valid(board_state: BoardState, unique_positions: Dictionary, position: Vector2i) -> void:
    if board_state.has_cell(position.y, position.x):
        unique_positions[position] = true


func _build_position_lookup(positions: Array) -> Dictionary:
    var lookup: Dictionary = {}

    for raw_position in positions:
        if raw_position is Vector2i:
            lookup[raw_position] = true

    return lookup


func _build_adjacent_lookup(board_state: BoardState, source_positions: Array) -> Dictionary:
    var lookup: Dictionary = {}

    for raw_position in source_positions:
        if raw_position is not Vector2i:
            continue

        var position: Vector2i = raw_position
        for direction in ORTHOGONAL_DIRECTIONS:
            _mark_if_valid(board_state, lookup, position + direction)

    return lookup


func _should_damage_cell(
    cell: BoardCell,
    position: Vector2i,
    direct_position_lookup: Dictionary,
    adjacent_position_lookup: Dictionary
) -> bool:
    if cell.obstacle_type == BoardCell.OBSTACLE_BOX:
        return direct_position_lookup.has(position) or adjacent_position_lookup.has(position)

    if cell.obstacle_type == BoardCell.OBSTACLE_ICE:
        return direct_position_lookup.has(position)

    if cell.obstacle_type == BoardCell.OBSTACLE_GRASS:
        return direct_position_lookup.has(position)

    if cell.obstacle_type == BoardCell.OBSTACLE_DENSE_GRASS:
        return direct_position_lookup.has(position)

    return direct_position_lookup.has(position)
