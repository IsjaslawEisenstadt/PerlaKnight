tool
extends Interaction
class_name Checkpoint

onready var AnimationPlayer := $AnimationPlayer

export var default: bool

var last_position: Vector2

func _interact(character) -> void:
	last_position = character.position
	character.current_checkpoint = self
	activate()

func _can_interact(character) -> bool:
	return "current_checkpoint" in character && character.current_checkpoint != self

func activate() -> void:
	AnimationPlayer.play("activate")

func activate_immediately() -> void:
	AnimationPlayer.play("activate")
	AnimationPlayer.advance(AnimationPlayer.get_animation("activate").length)

func deactivate() -> void:
	if AnimationPlayer.current_animation_position != 0:
		AnimationPlayer.play_backwards("activate")
		AnimationPlayer.seek(AnimationPlayer.current_animation_position, true)
