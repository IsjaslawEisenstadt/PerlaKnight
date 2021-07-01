extends AudioStreamPlayer
class_name MusicPlayer

export(Array, AudioStream) var dungeon_music: Array
export(Array, AudioStream) var forest_music: Array

var current_level_type: int = -1

func _on_PlayState_level_changed(level: Level) -> void:
	match level.level_type:
		level.LevelTypes.DUNGEON: 
			play_ambience(level.level_type, dungeon_music)
		_:
			play_ambience(level.level_type, forest_music)

func play_ambience(next_level_type: int, music: Array) -> void :
	if current_level_type != next_level_type:
		current_level_type = next_level_type
		if !music.empty():
			stream = music[randi() % music.size()]
			play()

func _on_Music_finished() -> void:
	if current_level_type == 0:
		play_ambience(current_level_type, dungeon_music)
	else:
		play_ambience(current_level_type, forest_music)
