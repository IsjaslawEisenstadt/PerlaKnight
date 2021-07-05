tool
extends AudioPlayer
class_name RandomAudioPlayer

export(Array, AudioStream) var sounds

var prev_sound

func _play(_demo: bool = false) -> void:
	if sounds.empty():
		._play()
	else:
		var next_sound = sounds[randi() % sounds.size()]
		if prev_sound && sounds.size() > 1:
			while next_sound == prev_sound:
				next_sound = sounds[randi() % sounds.size()]
		prev_sound = next_sound
		stream = next_sound
		._play()
