extends PhysicsState
class_name FallState

"""
This state will occur when the character is not on the floor and y velocity is pointing downwards
"""

onready var JumpState := get_node_or_null(jump_state_path) as CharacterState
onready var FastLandState := get_node_or_null(fast_land_state_path) as CharacterState
onready var SlowLandState := get_node_or_null(slow_land_state_path) as CharacterState
onready var DashState := get_node_or_null(dash_state_path) as CharacterState

export var jump_state_path: NodePath = "../JumpState"
export var fast_land_state_path: NodePath = "../FastLandState"
export var slow_land_state_path: NodePath = "../SlowLandState"
export var dash_state_path: NodePath = "../../Move/DashState"

export var slow_landing_fall_time: float = 0.5
export var without_landing: bool = true

# a coyote jump is a jump that's allowed even though the character is already falling
# it improves the smoothness of the platforming and makes it a bit more forgiving
# this is the timeframe during which a coyote jump is allowed after the fall starts
export var coyote_jump_time: float = 0.07

# coyote jump is only allowed when falling after moving
var _was_moving: bool = false

var _fall_time: float = 0.0

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)

	_fall_time = 0.0
	_was_moving = previous_state is MoveState

func _state_process(delta: float) -> void:
	._state_process(delta)
	
	if host.InputController._is_action_just_activated("dash"):
		if state_machine._pop_push(DashState):
			return
	
	_fall_time += delta
	
	if _was_moving && host.InputController._is_action_just_activated("jump") && _fall_time < coyote_jump_time:
		if state_machine._pop_push(JumpState):
			return
	
	if host.can_double_jump && host.InputController._is_action_just_activated("jump"):
		if state_machine._pop_push(JumpState):
			host.can_double_jump = false
			return

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)

	current_move_direction = host.InputController._get_move_direction()
	
	if current_move_direction != 0 && current_move_direction != host.look_direction:
		host.look_direction = current_move_direction

	fall(delta)
	move(delta)
	host.velocity = host.move_and_slide(host.velocity, FLOOR_DIRECTION)

	if host.is_on_floor():
		if without_landing:
			state_machine._pop_state()
			return
		else:
			if _fall_time >= slow_landing_fall_time:
				if state_machine._pop_push(SlowLandState):
					return
			if state_machine._pop_push(FastLandState):
				return
