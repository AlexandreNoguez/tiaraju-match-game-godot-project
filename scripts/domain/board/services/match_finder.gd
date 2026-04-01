extends RefCounted
class_name MatchFinder


func find_matches(board_state: BoardState) -> Array:
    var matches: Array = []

    for row in range(board_state.height):
        var horizontal_run: Array[Vector2i] = []
        var current_horizontal_color: String = ""

        for column in range(board_state.width):
            var piece: Variant = board_state.get_piece(row, column)
            if piece == null:
                _append_match_if_needed(matches, horizontal_run, "horizontal")
                horizontal_run = []
                current_horizontal_color = ""
                continue

            if piece.color_id == current_horizontal_color:
                horizontal_run.append(Vector2i(column, row))
            else:
                _append_match_if_needed(matches, horizontal_run, "horizontal")
                horizontal_run = [Vector2i(column, row)]
                current_horizontal_color = piece.color_id

        _append_match_if_needed(matches, horizontal_run, "horizontal")

    for column in range(board_state.width):
        var vertical_run: Array[Vector2i] = []
        var current_vertical_color: String = ""

        for row in range(board_state.height):
            var piece: Variant = board_state.get_piece(row, column)
            if piece == null:
                _append_match_if_needed(matches, vertical_run, "vertical")
                vertical_run = []
                current_vertical_color = ""
                continue

            if piece.color_id == current_vertical_color:
                vertical_run.append(Vector2i(column, row))
            else:
                _append_match_if_needed(matches, vertical_run, "vertical")
                vertical_run = [Vector2i(column, row)]
                current_vertical_color = piece.color_id

        _append_match_if_needed(matches, vertical_run, "vertical")

    return matches


func _append_match_if_needed(matches: Array, run_positions: Array, orientation: String) -> void:
    if run_positions.size() < 3:
        return

    matches.append(
        {
            "cells": run_positions.duplicate(),
            "orientation": orientation,
            "size": run_positions.size()
        }
    )
