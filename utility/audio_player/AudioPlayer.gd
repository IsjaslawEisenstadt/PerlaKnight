tool
extends AudioStreamPlayer2D
class_name AudioPlayer

export var demo: bool = false setget _play

func _play(_demo: bool = false) -> void:
	if stream:
		play()
