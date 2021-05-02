extends Interaction
class_name Checkpoint

var last_position: Vector2

func _interact(character) -> void:
	if character.current_checkpoint != self:
		character.current_checkpoint = self
		last_position = character.position

func _can_interact(character) -> bool:
	return "current_checkpoint" in character

func activate():
	$AnimationPlayer.play("activate")

func activate_immediately() -> void:
	$AnimationPlayer.play("activate")
	$AnimationPlayer.advance($AnimationPlayer.get_animation("activate").length)

func deactivate():
	if $AnimationPlayer.current_animation_position != 0:
		$AnimationPlayer.play_backwards("activate")
		$AnimationPlayer.seek($AnimationPlayer.current_animation_position, true)
