tool
extends PhysicsState
class_name DeathState

signal death_animation_finished()

export var will_despawn: bool = false
export var time_to_despawn: float = 3.0

export var force_animation: bool = false

export var death_sound: String = "Death"

var collision_layer: int = 0
var collision_mask: int = 1

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	host.play_sound(death_sound)
	
	host.collision_layer = collision_layer
	host.collision_mask = collision_mask
	host.remove_child(host.Colliders)
	host.Colliders.queue_free()
	
	host.velocity.x = 0.0
	
	if force_animation:
		host.AnimationPlayer.play(animation_name)
		host.HurtPlayer.stop()

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)
	fall(delta)
	move(delta)
	apply_velocity()

func _on_animation_finished(finished_animation_name: String) -> void:
	if finished_animation_name == animation_name: 
		emit_signal("death_animation_finished")
		if will_despawn:
			yield(get_tree().create_timer(time_to_despawn, false), "timeout")
			host.queue_free()

func _state_exit(_next_state: State, _params: Dictionary = {}) -> void:
	assert(false, "Can't leave a DeathState")

# this is required to export collision layers
func _get_property_list() -> Array:
	return [
	{
		"name": "collision_layer",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_LAYERS_2D_PHYSICS
	},
	{
		"name": "collision_mask",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_LAYERS_2D_PHYSICS
	}]
