extends GameState
class_name PauseMenu

onready var MainMenu := $".."/MainMenu
export(String, FILE, "*.tscn,*.scn,*.ldtk") var new_game_scene_path: String

func _ready() -> void:
	if OS.has_feature("HTML5"):
		$Margin/VBox/ButtonCenter/ButtonVBox/ExitButton.visible = false

func _on_BackToMenuButton_pressed():
	#Maybe save-logic here
	if state_machine._pop_push(MainMenu):
		return
	pass

func _on_ContinueButton_pressed():
	if state_machine._pop_state():
		return
