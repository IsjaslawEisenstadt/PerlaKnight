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

export(Array, String) var random_animations := []
export var random_animation_wait_time: float = 1.5
export var random_animation_wait_deviation: float = 0.5

var random_animation_wait_timer: Timer

func _ready() -> void:
	if !random_animations.empty():
		random_animation_wait_timer = Timer.new()
		random_animation_wait_timer.one_shot = true
		add_child(random_animation_wait_timer)
		random_animation_wait_timer.connect("timeout", self, "on_random_animation")

func get_random_wait_time() -> float:
	return rand_range(random_animation_wait_time - random_animation_wait_deviation,
					  random_animation_wait_time + random_animation_wait_deviation)

func on_random_animation() -> void:
	play_animation(random_animations[randi() % random_animations.size()])

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	host.velocity.x = 0.0
	if random_animation_wait_timer:
		random_animation_wait_timer.start(get_random_wait_time())

func _state_process(delta: float) -> void:
	._state_process(delta)

	if host.InputController._is_action_just_activated("jump"):
		if state_machine._push_state(JumpState):
			return
	if host.InputController._is_moving():
		if state_machine._push_state(MoveState):
			return
	if host.InputController._is_action_just_activated("dash"):
		if state_machine._push_state(DashState):
			return

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)

	fall(delta)
	host.velocity = host.move_and_slide(host.velocity, FLOOR_DIRECTION, true)

	if !host.is_on_floor():
		if state_machine._push_state(FallState):
			return

func _state_exit(_next_state: State) -> void:
	if random_animation_wait_timer:
		random_animation_wait_timer.stop()

func _on_animation_finished(finished_animation_name: String) -> void:
	._on_animation_finished(finished_animation_name)
	play_animation()
	if random_animation_wait_timer:
		random_animation_wait_timer.start(get_random_wait_time())
