tool
extends AudioPlayer
class_name RandomAudioPlayer

export(Array, AudioStream) var sounds

func _play(_demo: bool = false) -> void:
	if sounds.empty():
		._play()
	else:
		stream = sounds[randi() % sounds.size()]
		play()
