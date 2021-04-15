extends StateMachine
class_name CharacterStateMachine

onready var Host := get_node(host_path) as Character
onready var StartState := get_node(start_state_path) as State

export var host_path: NodePath = ".."
export var start_state_path: NodePath = "IdleState"

func _push_state(next_state: State, params = null) -> bool:
	if next_state:
		assert(next_state is CharacterState)
		next_state.host = Host
		return ._push_state(next_state, params)
	return false

func start() -> void:
	_push_state(StartState)
