extends PhysicsState
class_name JumpState

"""
The character is jumping! The sooner jump is released the smaller the jump height will be.
As soon as the y velocity is greater or equal to 0 it will transition to the fall state.
"""

onready var FallState := get_node_or_null(fall_state_path) as CharacterState

export var max_jump_height: float = 100.0
export var min_jump_height: float = 20.0

export var fall_state_path: NodePath = "../FallState"

export var use_mid_jump_animation: bool = false
export var mid_jump_animation: String = ""
export var mid_jump_animation_speed: float = 1.0

var _accelerating: bool
var _initial_velocity_y: float
var _time_to_apex: float
var _time: float

func _state_enter(previous_state: State, _params = null) -> void:
	._state_enter(previous_state)

	_accelerating = host.InputController._is_action_active("jump")
	_initial_velocity_y = sqrt(2 * GRAVITY * (max_jump_height if _accelerating else min_jump_height))
	_time_to_apex = _initial_velocity_y / GRAVITY
	_time = 0
	host.velocity.y = -_initial_velocity_y

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)

	current_move_direction = host.InputController._get_move_direction()
	
	if current_move_direction != 0 && current_move_direction != host.look_direction:
		host.look_direction = current_move_direction

	if _accelerating:
		_time += delta
		if host.InputController._is_action_just_deactivated("jump"):
			var new_jump_height = min_jump_height + lerp(min_jump_height, max_jump_height, _time / _time_to_apex)
			host.velocity.y += _initial_velocity_y - sqrt(2 * GRAVITY * new_jump_height)
			_accelerating = false

	fall(delta)
	move(delta)
	host.velocity = host.move_and_slide(host.velocity, FLOOR_DIRECTION)

	if host.velocity.y >= 0.0:
		# pop this state and push the next one
		if state_machine._pop_push(FallState):
			return

func _on_animation_finished(finished_animation_name: String) -> void:
	if use_mid_jump_animation && finished_animation_name == animation_name:
		host.play_animation(mid_jump_animation, mid_jump_animation_speed)
