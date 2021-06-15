extends Trigger
class_name Pillar

func _on_switch_triggered(activated):
	
	if not activated:
		$AnimationPlayer.play("Trigger")
	else:
		$AnimationPlayer.play_backwards("Trigger")
