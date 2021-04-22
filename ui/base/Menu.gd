extends GameState
class_name Menu

"""
Base state for all menus of the 'start/main menu'.
Makes itself visible when the state is entered.
"""

onready var DefaultFocus := get_node_or_null(default_focus_path) as Control

export var default_focus_path: NodePath

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	if DefaultFocus:
		DefaultFocus.grab_focus()
