tool
extends Area2D
class_name Doorway

export var next_level: String
export var next_door: String

# when the player enters a level through this door
# she will walk into this direction 
export var exit_direction: int
