tool
extends Area2D
class_name Doorway

onready var SpawnPosition: Position2D = $SpawnPosition

export var next_level: String
export var next_door: String

# when the player enters a level through this door
# she will walk into this direction
export var exit_direction: int
export var shape: Vector2 setget set_shape

func set_shape(new_shape: Vector2) -> void:
	shape = new_shape
	var collision_shape := $CollisionShape2D.shape as RectangleShape2D
	if collision_shape:
		collision_shape.extents = shape / 2
		$CollisionShape2D.position = shape / 2
		# use of hard link because set_shape can be called before ready
		$SpawnPosition.position.x = shape.x / 2
		$SpawnPosition.position.y = shape.y
