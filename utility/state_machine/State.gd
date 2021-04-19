extends Node
class_name State

"""
Base Class for all states used by the abstract StateMachine class
the state machine variable will be automatically supplied by the state machine
when the state is pushed onto the state stack
"""

var state_machine

func _state_enter(_previous_state: State, _params: Dictionary = {}) -> void:
	pass

func _state_process(_delta: float) -> void:
	pass

func _state_physics_process(_delta: float) -> void:
	pass

func _state_exit(_next_state: State) -> void:
	pass

func _can_enter() -> bool:
	return true

func is_active() -> bool:
	return state_machine && state_machine.get_current_state() == self
