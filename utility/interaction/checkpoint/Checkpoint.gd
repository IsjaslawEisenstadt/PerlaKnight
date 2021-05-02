extends Interaction
class_name Checkpoint

var last_position: Vector2

func _interact(character) -> void:
	character.last_checkpoint = self
	last_position = character.position
