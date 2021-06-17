extends AttackState
class_name IdleState

"""
For when the character has nothing to do
"""

onready var MoveState := get_node_or_null(move_state_path) as CharacterState
onready var JumpState := get_node_or_null(jump_state_path) as CharacterState
onready var FallState := get_node_or_null(fall_state_path) as CharacterState
onready var DashState := get_node_or_null(dash_state_path) as CharacterState

export var move_state_path: NodePath = "../Move/MoveState"
export var jump_state_path: NodePath = "../Jump/JumpState"
export var fall_state_path: NodePath = "../Jump/FallState"
export var dash_state_path: NodePath = "../Move/DashState"

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	check_input()
	check_physics()
	
	#host.velocity.x = 0.0

func _state_process(delta: float) -> void:
	._state_process(delta)
	if check_input():
		return
	if check_physics():
		return

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)

	fall(delta)
	move(delta)
	apply_velocity(false)
	
	check_physics()

func check_input() -> bool:
	if host.InputController._is_action_active("jump"):
		if state_machine._push_state(JumpState):
			return true
	if host.InputController._is_moving():
		if state_machine._push_state(MoveState):
			return true
	if host.InputController._is_action_just_activated("dash"):
		if state_machine._push_state(DashState):
			return true
	return false

func check_physics() -> bool:
	if !host.is_on_floor():
		if state_machine._push_state(FallState):
			return true
	return false
