extends PhysicsState
class_name MoveState

onready var IdleState := get_node_or_null(idle_state_path) as CharacterState
onready var TurnState := get_node_or_null(turn_state_path) as CharacterState
onready var JumpState := get_node_or_null(jump_state_path) as CharacterState
onready var FallState := get_node_or_null(fall_state_path) as CharacterState

export var idle_state_path: NodePath = "../../IdleState"
export var turn_state_path: NodePath = "../TurnState"
export var jump_state_path: NodePath = "../../Jump/JumpState"
export var fall_state_path: NodePath = "../../Jump/FallState"

export var without_turn_state: bool = true

func _state_enter(previous_state: State, _params = null) -> void:
	._state_enter(previous_state)

func _state_process(delta: float) -> void:
	._state_process(delta)

	current_move_direction = host.InputController._get_move_direction()
	if current_move_direction != 0.0 && current_move_direction != host.look_direction:
		if without_turn_state:
			host.velocity.x = 0.0
			host.look_direction *= -1
		elif state_machine._push_state(TurnState):
			return

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)

	fall(delta, true)
	move(delta)
	host.velocity = host.move_and_slide_with_snap(host.velocity, SNAP_DISTANCE, FLOOR_DIRECTION, true, MAX_SLIDES, MAX_FLOOR_ANGLE)

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
