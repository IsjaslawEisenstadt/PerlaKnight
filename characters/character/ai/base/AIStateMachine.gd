extends StateMachine
class_name AIStateMachine

"""
a state machine for AI states, it's base state is called AI
works like a regular state machine but also supplies AI states with the host
and input_controller
"""

var host: Character
var input_controller: Node

func _push_state(next_state: State, params: Dictionary = {}) -> bool:
	assert(host && input_controller)

	if next_state:
		next_state.host = host
		next_state.input_controller = input_controller
		return ._push_state(next_state, params)
	return false
