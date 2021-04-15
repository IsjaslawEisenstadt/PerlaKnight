extends Node
class_name InputController

"""
an abstract base class for all types of input
it allows to seamlessly switch between player and AI input
"""

# used only for AI input
func _start(_host) -> void:
	pass

# used only for AI input
func _input_process(_delta: float) -> void:
	pass

func _is_action_active(_name: String) -> bool:
	return false

func _is_action_just_activated(_name: String) -> bool:
	return false

func _is_action_just_deactivated(_name: String) -> bool:
	return false
