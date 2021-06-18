extends AnimationPlayer
class_name HurtPlayer

onready var Host := get_node(host_path) as Character

export var host_path: NodePath = ".."

export var hurt_animation_name: String = "hurt"
export var kickback_strength: float = 550.0
export var makes_invincible: bool = true

func _ready() -> void:
	yield(get_tree(), "idle_frame")
	Host.AnimationPlayer.connect("animation_finished", self, "on_host_animation_finished")

func hurt(attacker: Node2D) -> void:
	Host.invincible = makes_invincible
	
	var direction := int(sign(attacker.global_position.x - Host.global_position.x))
	if direction != 0 && kickback_strength > 0.0:
		Host.look_direction = direction
	
	Host.kickback_velocity.x = kickback_strength * -direction
	Host.kickback_velocity.y = ((Host.global_position - attacker.global_position).normalized() * kickback_strength).y
	
	Host.move_speed_factor = 0.1
	
	Host.on_animation_finished(Host.AnimationPlayer.current_animation)
	
	Host.play_animation(hurt_animation_name)
	
	if has_animation(hurt_animation_name):
		play(hurt_animation_name)
		yield(self, "animation_finished")
	Host.invincible = false

func is_hurt_fx_playing() -> bool:
	return is_playing()

func is_hurt_anim_playing() -> bool:
	return Host.AnimationPlayer.current_animation == hurt_animation_name

func on_host_animation_finished(finished_animation_name: String) -> void:
	if finished_animation_name == hurt_animation_name:
		Host.kickback_velocity = Vector2.ZERO
		Host.move_speed_factor = 1.0
		var current_state: CharacterState = Host.StateMachine.get_current_state()
		if current_state is AnimationState:
			current_state.play_animation()
