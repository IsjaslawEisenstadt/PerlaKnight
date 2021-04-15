extends State
class_name CharacterState

"""
base state for the CharacterStateMachine, provides the host to all character states
"""

#warning-ignore:unused_class_variable
var host: Character setget _set_host

func _set_host(value: Character) -> void:
	host = value

func _can_interact() -> bool:
	return true
