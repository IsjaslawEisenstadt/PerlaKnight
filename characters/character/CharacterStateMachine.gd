extends StateMachine
class_name CharacterStateMachine

onready var StartState := get_node(start_state_path) as State

export var start_state_path: NodePath = "IdleState"

func _push_state(next_state: State, params: Dictionary = {}) -> bool:
	assert(next_state is CharacterState)
	return ._push_state(next_state, params)

func start() -> void:
	var start_success = _push_state(StartState)
	assert(start_success)
