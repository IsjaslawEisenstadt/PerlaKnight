extends Area2D
class_name Destructible

export var destruct_animation_name: String = "destruct"

func on_body_entered(_body) -> void:
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play(destruct_animation_name)

func on_animation_finished(anim_name):
	if anim_name == destruct_animation_name:
		get_parent().remove_child(self)
		queue_free()
