tool
extends AudioStreamPlayer2D
class_name AudioPlayer

onready var NextSound: AudioPlayer = get_node_or_null(next_sound_path)

export var demo: bool = false setget _play

export var next_sound_path: NodePath

func _play(_demo: bool = false) -> void:
	if stream:
		play()
	
	if NextSound:
		NextSound._play()
