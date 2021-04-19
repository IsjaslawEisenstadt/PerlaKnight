extends PhysicsState
class_name JumpState

"""
The character is jumping! The sooner jump is released the smaller the jump height will be.
As soon as the y velocity is greater or equal to 0 it will transition to the fall state.
"""

onready var FallState := get_node_or_null(fall_state_path) as CharacterState
onready var DashState := get_node_or_null(dash_state_path) as CharacterState
onready var WallJumpState := get_node_or_null(wall_jump_state_path) as CharacterState

export var fall_state_path: NodePath = "../FallState"
export var dash_state_path: NodePath = "../../Move/DashState"
export var wall_jump_state_path: NodePath = "../WallJumpState"

export var max_jump_height: float = 100.0
export var min_jump_height: float = 20.0

export var use_mid_jump_animation: bool = false
export var mid_jump_animation: String = ""
export var mid_jump_animation_speed: float = 1.0

var accelerating: bool
var initial_velocity_y: float
var time_to_apex: float
var jump_time: float

var input_delay_timer: Timer

func _ready() -> void:
	input_delay_timer = Timer.new()
	input_delay_timer.one_shot = true
	add_child(input_delay_timer)

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	if "input_delay" in params:
		input_delay_timer.start(params.input_delay)
		current_move_direction = -host.look_direction
	
	accelerating = true
	initial_velocity_y = sqrt(2 * GRAVITY * (max_jump_height if accelerating else min_jump_height))
	time_to_apex = initial_velocity_y / GRAVITY
	jump_time = 0.0
	host.velocity.y = -initial_velocity_y

func _state_process(delta: float) -> void:
	._state_process(delta)
	
	if host.InputController._is_action_just_activated("dash"):
		if state_machine._pop_push(DashState):
			return
	
	if input_delay_timer.is_stopped() && host.can_double_jump && host.InputController._is_action_just_activated("jump"):
		if state_machine._pop_push(self):
			host.can_double_jump = false
			return

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)
	
	if input_delay_timer.is_stopped():
		current_move_direction = host.InputController._get_move_direction()
	
	if current_move_direction != 0 && current_move_direction != host.look_direction:
		host.look_direction = current_move_direction

	if accelerating:
		jump_time += delta
		if input_delay_timer.is_stopped() && host.InputController._is_action_just_deactivated("jump"):
			var new_jump_height = min_jump_height + lerp(min_jump_height, max_jump_height, jump_time / time_to_apex)
			host.velocity.y += initial_velocity_y - sqrt(2 * GRAVITY * new_jump_height)
			accelerating = false

	fall(delta)
	move(delta)
	host.velocity = host.move_and_slide(host.velocity, FLOOR_DIRECTION)

	if host.velocity.y >= 0.0:
		if state_machine._pop_push(FallState):
			return
	
	if input_delay_timer.is_stopped() && host.is_on_wall():
		if state_machine._pop_push(WallJumpState):
			return

func _state_exit(_next_state: State) -> void:
	input_delay_timer.stop()

func _on_animation_finished(finished_animation_name: String) -> void:
	if use_mid_jump_animation && finished_animation_name == animation_name:
		host.play_animation(mid_jump_animation, mid_jump_animation_speed)
