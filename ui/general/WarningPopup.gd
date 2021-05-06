extends Popup

signal popup_closed(confirm)

func open() -> void:
	$AnimationPlayer.play("blur")
	popup()

func close(confirmed: bool) -> void:
	emit_signal("popup_closed", confirmed)
	$AnimationPlayer.play_backwards("blur")
	yield($AnimationPlayer, "animation_finished")
	visible = false
