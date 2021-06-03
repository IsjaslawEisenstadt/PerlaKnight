extends AudioStreamPlayer2D

export(Dictionary) var sounds

func load_play(action) -> void:
	stream = sounds[action]
	play()
