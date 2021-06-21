extends StateMachine
class_name SequenceStateMachine

var host: Character
var input_controller

func _push_state(next_state: State, params: Dictionary = {}) -> bool:
	assert(host && input_controller)

	if next_state:
		next_state.host = host
		next_state.input_controller = input_controller
		return ._push_state(next_state, params)
	return false
