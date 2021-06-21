extends PhysicsState
class_name WallJumpState

onready var JumpState := get_node_or_null(jump_state_path) as CharacterState
onready var DashState := get_node_or_null(dash_state_path) as CharacterState

onready var WallClimbTop = get_node(wall_climb_top_path) as Area2D
onready var WallClimbBottom = get_node(wall_climb_bottom_path) as Area2D

export var jump_state_path: NodePath = "../JumpState"
export var dash_state_path: NodePath = "../../Move/DashState"

export var wall_climb_top_path: NodePath = "../../../Colliders/WallClimbTop"
export var wall_climb_bottom_path: NodePath = "../../../Colliders/WallClimbBottom"

export var horizontal_jump_force: float = 400
export var friction: float = 0.85
export var input_delay: float = 0.1

func _can_enter() -> bool:
	var x = (host.wall_climb_acquired && !host.InputController._is_action_active("let_go") &&
			!WallClimbTop.get_overlapping_bodies().empty() &&
			!WallClimbBottom.get_overlapping_bodies().empty())
	return x

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	host.velocity = Vector2.ZERO
	host.kickback_velocity = Vector2.ZERO
	host.can_dash = true
	host.can_double_jump = true

func _state_process(delta: float) -> void:
	._state_process(delta)
	
	if host.InputController._is_action_just_activated("jump"):
		if state_machine._pop_push(JumpState, {"input_delay": input_delay}):
			host.look_direction *= -1
			host.velocity.x += horizontal_jump_force * host.look_direction
			return
	
	if host.InputController._is_action_just_activated("dash"):
		if state_machine._pop_push(DashState):
			host.look_direction *= -1
			return
	
	if host.InputController._is_action_just_activated("let_go"):
		host.look_direction *= -1
		state_machine._pop_state()
		return

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)
	
	fall(delta, true, friction)
	apply_velocity(delta)
	
	if host.is_on_floor() || !_can_enter():
		host.look_direction *= -1
		state_machine._pop_state()
		return
