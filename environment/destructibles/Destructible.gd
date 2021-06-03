extends Area2D
class_name Destructible

export var destruct_animation_name: String = "destruct"

func _ready() -> void:
	if !is_connected("area_entered", self, "on_area_entered"):
		connect("area_entered", self, "on_area_entered")

func _on_destroyed():
	pass

func on_area_entered(_area) -> void:
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play(destruct_animation_name)

func on_animation_finished(anim_name):
	if anim_name == destruct_animation_name:
		_on_destroyed()
		get_parent().remove_child(self)
		queue_free()
