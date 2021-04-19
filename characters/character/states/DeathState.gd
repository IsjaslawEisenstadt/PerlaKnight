tool
extends AnimationState
class_name DeathState

"""
A state that is entered on death of the character, with an optional LootTable export.
To easily export the collision layer/mask we override the _get_property_list() function.
The script must be in tool mode work properly.
"""

# the on death collision layer/mask for the host
var collision_layer: int = 8
var collision_mask: int = 0

export var loot_table: Resource

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	host.collision_layer = collision_layer
	host.collision_mask = collision_mask

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
