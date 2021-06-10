tool
extends AudioStreamPlayer2D
class_name SingleStreamPlayer

export var demo: bool = false setget _play

func _play(demo: bool = false) -> void:
	play()
