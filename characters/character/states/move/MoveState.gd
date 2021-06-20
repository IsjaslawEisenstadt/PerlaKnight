extends AttackState
class_name MoveState

enum TransitionMode {
	NO_TRANSITION = 0,
	TRANSITION_IN = 1,
	TRANSITION_OUT = 2,
	TRANSITION_IN_OUT = 3
}

onready var IdleState := get_node_or_null(idle_state_path) as CharacterState
onready var TurnState := get_node_or_null(turn_state_path) as CharacterState
onready var JumpState := get_node_or_null(jump_state_path) as CharacterState
onready var FallState := get_node_or_null(fall_state_path) as CharacterState
onready var DashState := get_node_or_null(dash_state_path) as CharacterState

export(TransitionMode) var transition_mode: int = TransitionMode.NO_TRANSITION
export var transition_in_animation: String = ""
export var transition_out_animation: String = ""

export var idle_state_path: NodePath = "../../IdleState"
export var turn_state_path: NodePath = "../TurnState"
export var jump_state_path: NodePath = "../../Jump/JumpState"
export var fall_state_path: NodePath = "../../Jump/FallState"
export var dash_state_path: NodePath = "../DashState"

export var without_turn_state: bool = true

export var move_sound: String = "Move"
var move_sound_vari: String = move_sound
var regex = RegEx.new()

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	if transition_mode & TransitionMode.TRANSITION_IN:
		play_animation(transition_in_animation)
	
	move_sound_vari = move_sound
	if !host.level_name:
		host.level_name =  get_parent().get_parent().get_parent().get_parent().get_parent().name
	regex.compile("^Level")
	if regex.search(host.level_name):
		move_sound_vari += "Stone"
	regex.compile("^TutorialLevel")
	if regex.search(host.level_name):
		move_sound_vari += "Gras"

func _state_process(delta: float) -> void:
	._state_process(delta)
	if !host.is_playing_sound(move_sound_vari):
			host.play_sound(move_sound_vari)

	if host.InputController._is_action_just_activated("dash"):
		if state_machine._push_state(DashState):
			return

	current_move_direction = host.InputController._get_move_direction()
	if !current_move_direction && (transition_mode & TransitionMode.TRANSITION_OUT) && !is_playing(transition_out_animation):
		play_animation(transition_out_animation)
	if current_move_direction && current_move_direction != host.look_direction:
		if without_turn_state:
			host.velocity.x = 0.0
			host.look_direction *= -1
		elif state_machine._push_state(TurnState):
			return

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)

	fall(delta, true)
	move(delta)
	apply_velocity()

	# is_on_floor() should always be called directly after move_and_slide
	if !host.is_on_floor():
		if state_machine._push_state(FallState):
			return

	if host.InputController._is_action_just_activated("jump"):
		if state_machine._push_state(JumpState):
			return

	if !host.InputController._is_moving() && abs(host.velocity.x) < VELOCITY_X_DEADZONE:
		host.velocity.x = 0.0
		if state_machine._push_state(IdleState):
			return

func _on_animation_finished(finished_animation_name: String) -> void:
	._on_animation_finished(finished_animation_name)
	if finished_animation_name == transition_in_animation:
		play_animation()
	elif finished_animation_name == transition_out_animation:
		if state_machine._push_state(IdleState):
			return
