tool
extends Interaction
class_name Lever

export var oneway: bool = false

func _interact(_character) -> void:
	if !$Switch.activated:
		$AnimationPlayer.play("trigger")
		$Switch.trigger(true)
	elif !oneway: 
		$AnimationPlayer.play_backwards("trigger")
		$Switch.trigger(false)

func on_animation_finished(_anim_name):
	$Switch.activated = !$Switch.activated
