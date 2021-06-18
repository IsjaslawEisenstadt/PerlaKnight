extends Node
class_name InputController

"""
an abstract base class for all types of input
it allows to seamlessly switch between player and AI input
"""

func _is_action_active(_name: String) -> bool:
	return false

func _is_action_just_activated(_name: String) -> bool:
	return false

func _is_action_just_deactivated(_name: String) -> bool:
	return false

# used by AI and SequenceControllers

func _input_process(_delta: float) -> void:
	pass

func _input_physics_process(_delta: float) -> void:
	pass

# TODO: make these non-virtual

func _is_moving() -> bool:
	return _get_move_direction() != 0

func _get_move_direction() -> int:
	var left: bool = _is_action_active("move_left")
	var right: bool = _is_action_active("move_right")
	return int(right) - int(left)
