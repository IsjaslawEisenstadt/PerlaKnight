extends PhysicsState
class_name HurtState

export var kickback_strength: float = 1000.0

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	assert("attacker" in params)
	var attacker: Node2D = params.attacker
	
	host.velocity = (host.position-attacker.position).normalized() * kickback_strength
	host.invincible = true
	var direction := int(sign(attacker.position.x - host.position.x))
	if direction != 0:
		host.look_direction = direction

func _on_animation_finished(finished_animation_name: String) -> void:
	._on_animation_finished(finished_animation_name)
	state_machine._pop_state()

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)
	# TODO: unify this with the current PhysicsState.move() function
	host.velocity *= pow(1.0 - current_move_damping, delta * 10.0)
	fall(delta)
	host.velocity = host.move_and_slide(host.velocity, FLOOR_DIRECTION)

func _state_exit(next_state: State) -> void:
	._state_exit(next_state)
	host.invincible = false
