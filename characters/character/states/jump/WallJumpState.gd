extends PhysicsState
class_name WallJumpState

onready var JumpState := get_node_or_null(jump_state_path) as CharacterState
onready var DashState := get_node_or_null(dash_state_path) as CharacterState

export var jump_state_path: NodePath = "../JumpState"
export var dash_state_path: NodePath = "../../Move/DashState"

export var horizontal_jump_force: float = 400
export var friction: float = 0.85
export var input_delay: float = 0.1

func _can_enter() -> bool:
	return  host.wall_climb_acquired && \
			host.WallClimbAssistantTop != null && !host.WallClimbAssistantTop.get_overlapping_bodies().empty() \
			&& host.WallClimbAssistantBottom != null && !host.WallClimbAssistantBottom.get_overlapping_bodies().empty() \

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	host.velocity.y = 0.0
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

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)
	
	if host.is_on_floor() || !_can_enter():
		host.look_direction *= -1
		state_machine._pop_state()
		return
	
	fall(delta, true, friction)
	host.velocity = host.move_and_slide_with_snap(host.velocity, SNAP_DISTANCE, FLOOR_DIRECTION, true, MAX_SLIDES, MAX_FLOOR_ANGLE)
