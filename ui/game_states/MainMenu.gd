extends GameState
class_name MainMenu

onready var LoadingScreen := $".."/LoadingScreen
onready var Transition := $".."/Transition

onready var ContinueButton := $Margin/VBox/ButtonCenter/ButtonVBox/ContinueButton
onready var ExitButton := $Margin/VBox/ButtonCenter/ButtonVBox/ExitButton

export(String, FILE, "*.tscn,*.scn,*.ldtk") var new_game_scene_path: String

var save_data: Dictionary

func _ready() -> void:
	if OS.has_feature("HTML5"):
		ExitButton.visible = false

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	if "save_data" in params:
		ContinueButton.visible = true
		ContinueButton.grab_focus()
		save_data = params.save_data
	else:
		ContinueButton.visible = false
		save_data = {}

func start_game(params: Dictionary = {"scene": new_game_scene_path}) -> void:
	Transition.start("fade_out")
	yield(Transition, "transition_finished")
	state_machine._pop_push(LoadingScreen, params)

func on_continue_pressed():
	start_game({"scene": save_data["current_level"], "save_data": save_data})

func on_new_game_pressed() -> void:
	start_game()

func on_exit_pressed() -> void:
	get_tree().quit()
