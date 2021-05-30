tool
extends PhysicsState
class_name DeathState

var collision_layer: int = 1
var collision_mask: int = 0

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	host.collision_layer = collision_layer
	host.collision_mask = collision_mask
	host.velocity.x = 0.0
	host.AudioMusicPlayer.load_play("i want to sleep forever")

func _state_physics_process(delta: float) -> void:
	._state_physics_process(delta)
	fall(delta)
	host.velocity = host.move_and_slide(host.velocity, FLOOR_DIRECTION, true)

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
