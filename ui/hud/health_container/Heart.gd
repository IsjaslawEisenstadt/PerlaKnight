tool
extends Control

export var is_filled: bool = true setget set_filled

func set_filled(new_is_filled: bool) -> void:
	if is_filled != new_is_filled:
		is_filled = new_is_filled
		$AnimationPlayer.play("fill" if is_filled else "deplete")
