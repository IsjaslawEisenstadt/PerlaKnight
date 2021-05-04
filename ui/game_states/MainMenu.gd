extends GameState
class_name MainMenu

onready var LoadingScreen := $".."/LoadingScreen
onready var Transition := $".."/Transition

export(String, FILE, "*.tscn,*.scn,*.ldtk") var new_game_scene_path: String

func _ready() -> void:
	if OS.has_feature("HTML5"):
		$Margin/VBox/ButtonCenter/ButtonVBox/ExitButton.visible = false

func _on_NewGameButton_pressed() -> void:
	Transition.start("fade_out")
	yield(Transition, "transition_finished")
	state_machine._pop_push(LoadingScreen, {"scene": new_game_scene_path})

func _on_ExitButton_pressed() -> void:
	get_tree().quit()
