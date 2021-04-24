extends StateMachine
class_name GameStateMachine

export var start_state_path: NodePath = "ScreenSpaceUI/MainMenu"

func _ready() -> void:
	var start_state := get_node(start_state_path) as GameState
	assert(start_state)
	_push_state(start_state)

func _process(delta: float) -> void:
	_state_machine_process(delta)

func _physics_process(delta: float) -> void:
	_state_machine_physics_process(delta)
