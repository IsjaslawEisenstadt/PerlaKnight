extends InputController
class_name PlayerController

"""
the input controller for player input
returns actions based on input
"""

func _is_action_active(name: String) -> bool:
	return Input.is_action_pressed(name)

func _is_action_just_activated(name: String) -> bool:
	return Input.is_action_just_pressed(name)

func _is_action_just_deactivated(name: String) -> bool:
	return Input.is_action_just_released(name)
