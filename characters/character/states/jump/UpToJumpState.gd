extends AnimationState
class_name UpToJumpState

onready var NextState := get_node_or_null(next_state_path) as CharacterState

export var next_state_path: NodePath

func _on_animation_finished(_finished_animation_name: String) -> void:
	if NextState:
		state_machine._pop_push(NextState)
	else:
		state_machine._pop_state()
