extends GameState
class_name PlayState

signal saved_to_file()
signal level_changed(level)

# save files can become incompatible over time, with breaking changes being a real possibility.
# a version number saved in these files will give us the chance to not read old save data
# in order to ensure proper functionality, especially during active development
const CURRENT_SAVE_VERSION: int = 5

const SAVE_FILE_PATH: String = "user://PerlaKnight.save"

enum EnterPlayMode {
	RELOAD,
	LOAD_LEVEL,
	LOAD_GAME,
	NEW_GAME,
	TUTORIAL
}

onready var PauseMenu = $".."/UI/PauseMenu
onready var Transition := $".."/UI/Transition
onready var PlayUI := $".."/UI/PlayUI
onready var KeyMap := $".."/UI/KeyMap

export(String, DIR) var levels_dir: String = "res://maps/test_map/levels"
export var new_game_level_name: String = "Crossroads"
export var new_game_tutorial_name: String = "Tutorial"

export var dungeon_background_scene: PackedScene = preload("res://maps/backgrounds/dungeon/DungeonBackground.tscn")
export var forest_background_scene: PackedScene = preload("res://maps/backgrounds/forest/ForestBackground.tscn")

var previous_level: Level
var current_level: Level
var save_data: Dictionary = {}
var levels: Dictionary = {}

func restore_previous_level() -> void:
	if previous_level:
		get_tree().paused = true
		Transition.start("fade")
		yield(Transition, "transition_finished")
		
		save_data["restore"] = true
		activate_level(previous_level.name)
		load_game()
		save_data.erase("restore")
		save_to_file()
		Transition.end()
		get_tree().paused = false

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
			if "tutorial_level" in save_data:
				next_level_name = save_data.tutorial_level
			elif "checkpoint_level" in save_data:
				next_level_name = save_data.checkpoint_level
			else:
				next_level_name = new_game_level_name
				reset_save_data()
				save_to_file()
		EnterPlayMode.NEW_GAME:
			next_level_name = new_game_level_name
			reset_save_data()
			save_to_file()
	return next_level_name

func unload_levels() -> void:
	previous_level = null
	if current_level:
		remove_child(current_level)
		current_level = null
	for level_name in levels.keys():
		levels[level_name].queue_free()
		levels.erase(level_name)

func load_level(level_name: String) -> void:
	var level: Level = load("%s/%s.tscn" % [levels_dir, level_name]).instance()
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
		previous_level = current_level
		previous_level.disconnect("save_requested", self, "save_game")
		previous_level.disconnect("save_to_file_requested", self, "save_to_file")
		previous_level.disconnect("transition_requested", self, "on_transition_requested")
		previous_level.disconnect("preload_requested", self, "load_level")
		previous_level.disconnect("restore_requested", self, "restore_previous_level")
		remove_child(previous_level)
	current_level = levels[level_name]
	add_child(current_level)
	current_level.connect("save_requested", self, "save_game")
	current_level.connect("save_to_file_requested", self, "save_to_file")
	current_level.connect("transition_requested", self, "on_transition_requested")
	current_level.connect("preload_requested", self, "load_level")
	current_level.connect("restore_requested", self, "restore_previous_level")
	current_level.set_ui(PlayUI)
	emit_signal("level_changed", current_level)

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	if "enter_play_mode" in params:
		if params.enter_play_mode == EnterPlayMode.TUTORIAL:
			activate_level(params.next_level_name)
			load_game()
			Transition.end()
			._state_enter(previous_state, params)
		else:
			var next_level_name: String = choose_next_level(params)
			unload_levels()
			
			if params.enter_play_mode == EnterPlayMode.NEW_GAME:
				load_level(new_game_tutorial_name)
			
			load_level(next_level_name)
			activate_level(next_level_name)
			load_game()
			
			if params.enter_play_mode == EnterPlayMode.NEW_GAME:
				activate_level(new_game_tutorial_name)
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
	
	if Input.is_action_just_pressed("help"):
		state_machine._push_state(KeyMap)

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

func save_to_file() -> void:
	var save_file := File.new()
	var err: int = save_file.open(SAVE_FILE_PATH, File.WRITE)
	assert(!err, "Couldn't open save file for writing!")
	save_file.store_string(JSON.print(save_data, "\t"))
	save_file.close()
	emit_signal("saved_to_file")

func load_game() -> void:
	assert(current_level)
	for node in get_tree().get_nodes_in_group("Persistent"):
		if node.has_method("load_game"):
			node.load_game(save_data, current_level)

func on_transition_requested(level_name, target_name, reset_override: bool = false) -> void:
	var params: Dictionary = {}

	var transition_name: String = "fade" if reset_override else "alpha"
	var pause_before_transition: bool = reset_override
	if level_name:
		if target_name:
			params["enter_play_mode"] = EnterPlayMode.LOAD_LEVEL
			params["next_level_name"] = level_name
			save_data["spawn_target"] = target_name
		else:
			params["enter_play_mode"] = EnterPlayMode.TUTORIAL
			params["next_level_name"] = level_name
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
	
	state_machine._pop_push(self, params)
