extends GameState
class_name MainMenu

onready var LoadingScreen := $".."/LoadingScreen
onready var Transition := $".."/Transition

export(String, FILE, "*.tscn,*.scn,*.ldtk") var new_game_scene_path: String

func _ready() -> void:
	if OS.has_feature("HTML5"):
		$Margin/VBox/ButtonCenter/ButtonVBox/ExitButton.visible = false

func new_game() -> void:
	Transition.start("fade_out")
	yield(Transition, "transition_finished")
	state_machine._pop_push(LoadingScreen, {"scene": new_game_scene_path})

func on_new_game_pressed() -> void:
	new_game()

func on_exit_pressed() -> void:
	get_tree().quit()
