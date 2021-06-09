extends SingleStreamPlayer
class_name AudioVariation

export(Array, AudioStream) var sounds

func _play() -> void:
	if sounds.empty():
		._play()
	else:
		stream = sounds[randi() % sounds.size()]
		play()
