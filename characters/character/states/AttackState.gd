extends PhysicsState
class_name AttackState

onready var AttackHitbox := get_node_or_null(attack_hitbox_path) as Area2D

export(Array, String) var attack_animations := []

export var attack_hitbox_path: NodePath = "../../AttackHitbox"
export var attack_damage: int = 1

var hit_characters := []
var frame_skipped: bool = false
var attack_queued: bool = false
var is_attacking: bool = false
var attack_index: int = 0

func _ready() -> void:
	if !attack_animations.empty() && AttackHitbox:
		AttackHitbox.connect("body_entered", self, "on_attack_hit")

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	if !attack_animations.empty():
		frame_skipped = false
		attack_queued = false
		is_attacking = false
		attack_index = 0
		
		# asking 'previous_state is AttackState' would result in a cyclic dependency
		# so we have to resort to duck typing
		if previous_state && "is_attacking" in previous_state && previous_state.is_attacking:
				is_attacking = true
				attack_index = previous_state.attack_index
				attack_queued = previous_state.attack_queued
				hit_characters = previous_state.hit_characters
				params["animation_override"] = {
					"animation_name": attack_animations[attack_index],
					"frame": host.AnimationPlayer.current_animation_position
				}
	
	._state_enter(previous_state, params)

func _state_process(delta: float) -> void:
	._state_process(delta)
	
	if !attack_animations.empty():
		if !frame_skipped:
			frame_skipped = true
		elif is_attacking && !attack_queued && host.InputController._is_action_just_activated("attack"):
			attack_queued = true
		
		# do this after attack_queued for a frame skip
		if !is_attacking && host.InputController._is_action_just_activated("attack"):
			is_attacking = true
			attack_queued = false
			play_animation(attack_animations[attack_index])

func _state_exit(next_state: State) -> void:
	._state_exit(next_state)
	hit_characters.clear()

func _on_animation_finished(finished_animation_name: String) -> void:
	._on_animation_finished(finished_animation_name)
	if finished_animation_name in attack_animations:
		hit_characters.clear()
		if attack_queued:
			attack_queued = false
			is_attacking = true
			attack_index = (attack_index + 1) % attack_animations.size()
			play_animation(attack_animations[attack_index])
		else:
			is_attacking = false
			attack_index = 0
			play_animation(animation_name, animation_speed, 0)

func on_attack_hit(body) -> void:
	if is_active() && body != self && body is Character && !body in hit_characters && !body.invincible:
		body.hit(host, attack_damage)
		hit_characters.append(body)
