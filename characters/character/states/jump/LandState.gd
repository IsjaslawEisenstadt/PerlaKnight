extends PhysicsState
class_name LandState

# dictates how much velocity (%) will be lost upon landing.
export(float, 0.0, 1.0) var slowdown: float = 1.0

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	host.velocity.x *= 1 - slowdown
	assert(host.AnimationPlayer.current_animation == animation_name)
	host.AudioMovementPlayer.load_play("fall_on_stone")

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)

	current_move_direction = host.InputController._get_move_direction()
	fall(delta, true)
	move(delta)
	host.velocity = host.move_and_slide_with_snap(host.velocity, SNAP_DISTANCE, FLOOR_DIRECTION, true, MAX_SLIDES, MAX_FLOOR_ANGLE)

func _on_animation_finished(_finished_animation_name: String) -> void:
	state_machine._pop_state()
