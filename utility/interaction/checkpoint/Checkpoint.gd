extends Interaction
class_name Checkpoint

onready var AnimationPlayer := $AnimationPlayer

var last_position: Vector2

func _interact(character) -> void:
	if character.last_checkpoint != self:
		character.set_checkpoint(self)
		last_position = character.position
		
		activate()

func activate():
	AnimationPlayer.play("activate")

func deactivate():
	AnimationPlayer.seek(0, true)
