extends PhysicsState
class_name HurtState

export var hurt_animation_name: String = "hurt"
export var kickback_strength: float = 550.0
export var makes_invincible: bool = true
export var pop_on_hurt: bool = false

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	if host.AnimationPlayer.current_animation == hurt_animation_name:
		params.animation_override = {}
		current_move_speed = move_speed * 0.1
	
	._state_enter(previous_state, params)

func _on_animation_finished(finished_animation_name: String) -> void:
	._on_animation_finished(finished_animation_name)
	
	if finished_animation_name == hurt_animation_name:
		host.kickback_velocity = Vector2.ZERO
		current_move_speed = move_speed
		play_animation()

func hurt(attacker: Node2D) -> void:
	host.invincible = makes_invincible
	
	var direction := int(sign(attacker.global_position.x - host.global_position.x))
	if direction != 0:
		host.look_direction = direction
	
	host.kickback_velocity.x = kickback_strength * -direction
	host.kickback_velocity.y = ((host.global_position - attacker.global_position).normalized() * kickback_strength).y
	
	current_move_speed = move_speed * 0.1
	
	play_animation(hurt_animation_name)
	
	if pop_on_hurt:
		state_machine._pop_state({"attacker": attacker})
