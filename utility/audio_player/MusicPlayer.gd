tool
extends AudioStreamPlayer
class_name MusicPlayer

export var demo: bool = false setget set_demo

export(Array, AudioStream) var dungeon_music: Array
export(Array, AudioStream) var forest_music: Array

export var dungeon_volume: float = -2.0
export var forest_volume: float = -6.0

export var pause_chance: float = 0.2
export var pause_length: float = 5.0
export var pause_deviation: float = 2.0

var current_level_type: int = -1

func set_demo(new_demo: bool) -> void:
	if new_demo:
		$Timer.stop()
		stop()
		play_music(randi() % 2)

func on_level_changed(level: Level) -> void:
	play_music(level.level_type)

func play_music(next_level_type: int = current_level_type) -> void:
	var music: Array
	match next_level_type:
		Level.LevelTypes.DUNGEON:
			music = dungeon_music
		_:
			music = forest_music
	
	if (playing || !$Timer.is_stopped()):
		if current_level_type != next_level_type:
			current_level_type = next_level_type
			stop()
			play_track(music)
	else:
		current_level_type = next_level_type
		play_track(music)

func play_track(from: Array) -> void:
	var pause_time: float = get_pause_time()
	if pause_time <= 0.0:
		if !from.empty():
			match current_level_type:
				Level.LevelTypes.DUNGEON:
					volume_db = dungeon_volume
				_:
					volume_db = forest_volume
			stream = pick_track(from)
			play()
	else:
		$Timer.start(pause_time)

func get_pause_time() -> float:
	if randf() <= pause_chance:
		return pause_length + ((randf() * pause_deviation * 2.0) - (pause_deviation / 2.0))
	return 0.0

func pick_track(from: Array):
	return from[randi() % from.size()]

func on_timeout():
	if !Engine.editor_hint:
		play_music()
