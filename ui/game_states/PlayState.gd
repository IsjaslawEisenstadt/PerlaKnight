extends GameState
class_name PlayState

# save files can become incompatible over time, with breaking changes being a real possibility.
# a version number saved in these files will give us the chance to not read old save data
# in order to ensure proper functionality, especially during active development
const CURRENT_SAVE_VERSION: int = 4

const SAVE_FILE_PATH: String = "user://PerlaKnight.save"

enum EnterPlayMode {
	RELOAD,
	LOAD_LEVEL,
	LOAD_GAME,
	NEW_GAME,
}

onready var PauseMenu = $".."/UI/PauseMenu
onready var Transition := $".."/UI/Transition
onready var PlayUI := $".."/UI/PlayUI

export(String, DIR) var levels_dir: String = "res://maps/test_map/levels"
export var new_game_level_name: String = "Level1"

export var dungeon_background_scene: PackedScene = preload("res://maps/backgrounds/dungeon/DungeonBackground.tscn")
export var forest_background_scene: PackedScene = preload("res://maps/backgrounds/forest/ForestBackground.tscn")

var current_level: Level
var save_data: Dictionary = {}
var levels: Dictionary = {}

func choose_next_level(params: Dictionary) -> String:
	var next_level_name: String
	match params.enter_play_mode:
		EnterPlayMode.RELOAD:
			assert(current_level)
			next_level_name = current_level.name
		EnterPlayMode.LOAD_LEVEL:
			assert("next_level_name" in params)
			next_level_name = params.next_level_name
		EnterPlayMode.LOAD_GAME:
			if "checkpoint_level" in save_data:
				next_level_name = save_data.checkpoint_level
			else:
				next_level_name = new_game_level_name
		EnterPlayMode.NEW_GAME:
			next_level_name = new_game_level_name
			reset_save_data()
	return next_level_name

func unload_levels() -> void:
	if current_level:
		remove_child(current_level)
		current_level = null
	for level_name in levels.keys():
		levels[level_name].queue_free()
		levels.erase(level_name)

func load_level(level_name: String) -> void:
	SceneLoader.load_scene("%s/%s.tscn" % [levels_dir, level_name])
	var level: Level = yield(SceneLoader, "load_finished").instance()
	assert(level && level is Level)
	
	var background_scene: PackedScene
	match level.level_type:
		Level.LevelTypes.FOREST:
			background_scene = forest_background_scene
		_:
			background_scene = dungeon_background_scene
	level.add_child(background_scene.instance(), true)
	
	levels[level_name] = level

func activate_level(level_name: String) -> void:
	if current_level:
		current_level.disconnect("save_requested", self, "save_game")
		current_level.disconnect("transition_requested", self, "on_transition_requested")
		current_level.disconnect("preload_requested", self, "load_level")
		remove_child(current_level)
	current_level = levels[level_name]
	add_child(current_level)
	current_level.connect("save_requested", self, "save_game")
	current_level.connect("transition_requested", self, "on_transition_requested")
	current_level.connect("preload_requested", self, "load_level")
	current_level.set_ui(PlayUI)

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	if "enter_play_mode" in params:
		var next_level_name: String = choose_next_level(params)
		unload_levels()
		yield(load_level(next_level_name), "completed")
		activate_level(next_level_name)
		load_game()
		
		._state_enter(previous_state, params)
		Transition.end()
	
	# no enter_play_mode required if we just want to resume (from e.g. the pause menu)
	else:
		assert(current_level, "entered PlayState without enter_play_mode param or previously active level")
		._state_enter(previous_state, params)

func _state_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		state_machine._push_state(PauseMenu)

func _ready() -> void:
	var save_file := File.new()
	var err: int = save_file.open(SAVE_FILE_PATH, File.READ)
	
	if err == ERR_FILE_NOT_FOUND:
		save_data = {
			"version": CURRENT_SAVE_VERSION
		}
	elif err:
		printerr("Error opening Save File!")
		save_data = {}
	else:
		save_data = parse_json(save_file.get_as_text())
		if !"version" in save_data || save_data.version != CURRENT_SAVE_VERSION:
			save_data = {}
	
	save_data["version"] = CURRENT_SAVE_VERSION
	save_file.close()

func reset_save_data() -> void:
	save_data = {
		"version": CURRENT_SAVE_VERSION
	}

func has_save_data() -> bool:
	# this accounts for the always present version number
	return save_data.size() > 1

func save_game() -> void:
	assert(current_level)
	for node in get_tree().get_nodes_in_group("Persistent"):
		if node.has_method("save_game"):
			node.save_game(save_data, current_level)
	
	var save_file := File.new()
	var err: int = save_file.open(SAVE_FILE_PATH, File.WRITE)
	assert(!err, "Couldn't open save file for writing!")
	save_file.store_string(JSON.print(save_data, "\t"))
	save_file.close()

func load_game() -> void:
	assert(current_level)
	for node in get_tree().get_nodes_in_group("Persistent"):
		if node.has_method("load_game"):
			node.load_game(save_data, current_level)

func on_transition_requested(level_name, target_name) -> void:
	var params: Dictionary = {}

	var transition_name: String = "alpha"
	var pause_before_transition: bool = false
	if level_name:
		assert(target_name)
		
		params["enter_play_mode"] = EnterPlayMode.LOAD_LEVEL
		params["next_level_name"] = level_name
		save_data["spawn_target"] = target_name
		
		transition_name = "fade"
		pause_before_transition = true
	elif "checkpoint_level" in save_data:
		params["enter_play_mode"] = EnterPlayMode.LOAD_GAME
	else:
		params["enter_play_mode"] = EnterPlayMode.NEW_GAME
	
	get_tree().paused = pause_before_transition
	Transition.start(transition_name)
	yield(Transition, "transition_finished")
	
	if !pause_before_transition:
		yield(get_tree().create_timer(0.4), "timeout")
	
	#get_tree().paused = true
	state_machine._pop_push(self, params)
