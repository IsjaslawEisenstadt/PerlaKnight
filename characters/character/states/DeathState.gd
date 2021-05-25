tool
extends PhysicsState
class_name DeathState

export var despawnable = false
export var time_to_despawn = 3

var collision_layer: int = 1
var collision_mask: int = 0

var despawn_timer : Timer

func _ready():
	despawn_timer = Timer.new()
	despawn_timer.one_shot = true
	add_child(despawn_timer)
	
	despawn_timer.connect("timeout", self, "despawn")

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	host.collision_layer = collision_layer
	host.collision_mask = collision_mask
	host.velocity.x = 0.0
	
	if despawnable:
		despawn_timer.start(time_to_despawn)
		
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
	
func despawn() -> void:
	host.queue_free()
