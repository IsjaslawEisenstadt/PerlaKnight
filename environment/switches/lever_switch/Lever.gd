extends Interaction
class_name Lever

signal switch_triggered(activated)

var triggered = false

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

func _interact(_character) -> void:
	if !triggered:
		$AnimationPlayer.play("trigger")
		emit_signal("switch_triggered", true)
	else: 
		$AnimationPlayer.play_backwards("trigger")
		emit_signal("switch_triggered", false)

func on_animation_finished(_anim_name):
	triggered = !triggered
