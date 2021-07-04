tool
extends AudioPlayer
class_name ChangeAudioPlayer

export(Array, AudioStream) var sounds
var i: int = 0

func _play(_demo: bool = false) -> void:
	if sounds.empty():
		._play()
	else :
		stream = sounds[i % sounds.size()]
		i += 1
		play()
