extends PhysicsState
class_name TurnState

"""
Will play the turn animation and change the character's facing direction.
"""

onready var JumpState := get_node_or_null(jump_state_path) as CharacterState
onready var FallState := get_node_or_null(fall_state_path) as CharacterState

export var jump_state_path: NodePath = "../../Jump/JumpState"
export var fall_state_path: NodePath = "../../Jump/FallState"

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)

	fall(delta, true)
	move(delta)
	apply_velocity()

	if host.AnimationPlayer.current_animation != animation_name:
		if host.velocity.x * current_move_direction > 0:
			state_machine._pop_state()
	if !host.is_on_floor():
		if state_machine._push_state(FallState):
			return
	if host.InputController._is_action_just_activated("jump"):
		if state_machine._push_state(JumpState):
			return

func _state_exit(next_state: State, params: Dictionary = {}) -> void:
	._state_exit(next_state, params)

	host.velocity.x = 0.0
	host.look_direction *= -1

func _on_animation_finished(_finished_animation_name: String) -> void:
	state_machine._pop_state()
