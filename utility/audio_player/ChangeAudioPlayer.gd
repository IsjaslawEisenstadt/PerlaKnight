tool
extends AudioPlayer
class_name ChangeAudioPlayer

export(String, DIR) var sound_dir setget set_sound_dir

export(Array, AudioStream) var sounds
var i: int = 0

func set_sound_dir(new_dir: String) -> void:
	if Engine.editor_hint:
		sound_dir = new_dir
		var dir = Directory.new()
		if dir.dir_exists(sound_dir):
			var err = dir.open(new_dir)
			if !err:
				sounds = []
				
				dir.list_dir_begin(true)
				
				var next_path = dir.get_next()
				while next_path != "":
					if !dir.current_is_dir() && next_path.ends_with(".wav"):
						sounds.append(load("%s/%s" % [dir.get_current_dir(), next_path]))
					next_path = dir.get_next()
			

func _play(_demo: bool = false) -> void:
	if sounds.empty():
		._play()
	else :
		stream = sounds[i % sounds.size()]
		i += 1
		._play()
