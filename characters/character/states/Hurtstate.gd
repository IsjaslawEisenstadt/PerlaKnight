extends PhysicsState
class_name HurtState

onready var IdleState := get_node(idle_state_path)

export var idle_state_path: NodePath = "../IdleState"

export var kickback_strength: float = 550.0

export var makes_invincible: bool = true

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	assert("attacker" in params)
	var attacker: Node2D = params.attacker
	
	host.invincible = makes_invincible
	var direction := int(sign(attacker.global_position.x - host.global_position.x))
	if direction != 0:
		host.look_direction = direction
	
	host.velocity.x = kickback_strength * -direction
	host.velocity.y = ((host.global_position - attacker.global_position).normalized() * kickback_strength).y

func _on_animation_finished(finished_animation_name: String) -> void:
	._on_animation_finished(finished_animation_name)
	state_machine._push_state(IdleState)

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)
	
	# TODO: unify this with the current PhysicsState.move() function
	host.velocity *= pow(1.0 - current_move_damping, delta * 10.0)
	fall(delta)
	
	host.velocity.x = clamp(host.velocity.x, -kickback_strength, kickback_strength)
	host.velocity.y = clamp(host.velocity.y, -kickback_strength, kickback_strength)
	
	host.velocity = host.move_and_slide(host.velocity, FLOOR_DIRECTION)

func _state_exit(next_state: State) -> void:
	._state_exit(next_state)
	host.invincible = false
