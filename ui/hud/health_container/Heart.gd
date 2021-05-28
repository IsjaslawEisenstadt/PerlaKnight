extends Control
class_name Heart

onready var AnimationPlayer := $AnimationPlayer

var filled: bool = false

func set_filled(new_is_filled: bool, complete_immediately: bool = false) -> void:
	filled = new_is_filled
	var animation_name: String = "fill" if filled else "deplete"
	AnimationPlayer.play(animation_name)
	if complete_immediately:
		AnimationPlayer.advance(AnimationPlayer.get_animation(animation_name).length)

func is_filled() -> bool:
	return filled
