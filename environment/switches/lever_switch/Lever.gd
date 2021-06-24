extends Interaction
class_name Lever

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

func _interact(_character) -> void:
	if !$Switch.activated:
		$AnimationPlayer.play("trigger")
		$Switch.trigger(true)
	else: 
		$AnimationPlayer.play_backwards("trigger")
		$Switch.trigger(false)

func on_animation_finished(_anim_name):
	$Switch.activated = !$Switch.activated
