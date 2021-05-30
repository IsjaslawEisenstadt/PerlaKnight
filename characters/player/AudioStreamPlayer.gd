extends AudioStreamPlayer

var jump_variation: Array = ["jump_grunt", "jump_grunt2"] 
var suffix: String = ".wav"
var prefix: String

func _ready():
	if get_name() == "AudioMusicPlayer":
		prefix = "res://music_sounds/music/"
	elif get_name() == "AudioMovementPlayer":
		prefix = "res://music_sounds/sound/movement/"
	else :
		prefix = "res://music_sounds/sound/attack/"

func load_play(action) -> void:
	if action == "jump_grunt":
		action = sound_variation(jump_variation)
	var path: String = prefix + action + suffix
	stream = load(path)
	play()

func sound_variation(variation: Array) -> String:
	var ran = RandomNumberGenerator.new()
	ran.randomize()
	var num = ran.randi_range(0, variation.size() - 1)
	return variation[num]

func _on_AudioStreamPlayer_finished():
	#next Music to play
	pass # Replace with function body.

