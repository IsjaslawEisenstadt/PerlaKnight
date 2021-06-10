extends Interaction
class_name Switch

signal switch_triggered(triggered)

var triggered = false

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

func _interact(character) -> void:
	if !triggered:
		$AnimationPlayer.play("Trigger")
	else: 
		$AnimationPlayer.play_backwards("Trigger")
		
func _can_interact(_character) -> bool:
	return true

func on_animation_finished(anim_name):
	triggered = !triggered
