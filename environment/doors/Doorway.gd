extends Area2D
class_name Doorway

# when the player enters a level through this door
# she will walk into this direction 
export var exit_direction: int

export(String, FILE, "*.tscn,*.scn,*.ldtk") var next_level_path: String
export var other_door_path: NodePath
