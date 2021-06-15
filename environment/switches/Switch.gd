extends Interaction
class_name Switch

signal switch_triggered(activated)

var triggered = false

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

func _interact(character) -> void:
	if !triggered:
		$AnimationPlayer.play("Trigger")
		emit_signal("switch_triggered", true)
	else: 
		$AnimationPlayer.play_backwards("Trigger")
		emit_signal("switch_triggered", false)

func on_animation_finished(anim_name):
	triggered = !triggered
