extends GameState
class_name PlayState

# warning-ignore:unused_signal
signal save_requested()

onready var PauseMenu = $".."/UI/PauseMenu
onready var Transition := $".."/UI/Transition
onready var PlayUI := $".."/UI/PlayUI
onready var LoadingScreen := $".."/UI/LoadingScreen

var current_level: Level

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	if "scene" in params:
		assert(params.scene is Level)
		if current_level:
			remove_child(current_level)
			current_level.queue_free()
		
		current_level = params.scene
		add_child(current_level)
		current_level.connect("save_requested", self, "emit_signal", ["save_requested"])
		current_level.connect("transition_requested", self, "on_transition_requested")
		current_level.set_ui(PlayUI)
		current_level.load_game(params.save_data if "save_data" in params else {})
		
		Transition.start("fade_in")
	else:
		assert(current_level, "entered PlayState without level param or previously active level")

func _state_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		state_machine._push_state(PauseMenu)

func on_transition_requested(level_path, target_path) -> void:
	get_tree().paused = true
	var temp_save_data: Dictionary = {}
	temp_save_data["current_level"] = current_level.filename # for consistency
	current_level.save_game(temp_save_data)
	temp_save_data["current_level"] = level_path
	temp_save_data["spawn_target"] = target_path
	Transition.start("fade_out")
	yield(Transition, "transition_finished")
	remove_child(current_level)
	current_level.queue_free()
	current_level = null
	state_machine._pop_push(LoadingScreen, {"scene": level_path, "save_data": temp_save_data})
	
