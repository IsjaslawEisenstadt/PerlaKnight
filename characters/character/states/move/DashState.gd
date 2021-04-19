extends PhysicsState
class_name DashState

onready var FallState := get_node_or_null(fall_state_path) as CharacterState

export var fall_state_path: NodePath = "../../Jump/FallState"
export var ground_dash_end_animation: String = "dash_end"
export var ground_dash_end_animation_speed: float = 1.0
export var ground_dash_end_damping: float = 0.5

var travel_finished: bool = false

var on_cooldown: bool = false

func _process(_delta: float) -> void:
	if on_cooldown && !is_active() && host.is_on_floor():
		on_cooldown = false

func _can_enter() -> bool:
	return host.dash_acquired && !on_cooldown

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	travel_finished = false
	on_cooldown = true

func _state_process(delta: float) -> void:
	._state_process(delta)

	current_move_direction = host.look_direction
	host.velocity.y = 0.0

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)

	if travel_finished && !host.is_on_floor():
		state_machine._pop_push(FallState)

	#fall(delta, true)
	move(delta)
	host.velocity = host.move_and_slide_with_snap(host.velocity, SNAP_DISTANCE, FLOOR_DIRECTION, true, MAX_SLIDES, MAX_FLOOR_ANGLE)

func _on_animation_finished(finished_animation_name: String) -> void:
	if finished_animation_name == animation_name:
		travel_finished = true
		current_move_damping = ground_dash_end_damping
		if host.is_on_floor():
			host.play_animation(ground_dash_end_animation, ground_dash_end_animation_speed)
		else:
			state_machine._pop_push(FallState)
	else:
		state_machine._pop_state()
