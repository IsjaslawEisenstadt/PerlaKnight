extends GameState
class_name PauseMenu

onready var MainMenu := $".."/MainMenu
export(String, FILE, "*.tscn,*.scn,*.ldtk") var new_game_scene_path: String

var last_scene

func _ready() -> void:
	if OS.has_feature("HTML5"):
		$Margin/VBox/ButtonCenter/ButtonVBox/ExitButton.visible = false

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	last_scene = params.scene

func _on_BackToMenuButton_pressed():
	#Maybe save-logic here
	
	last_scene.queue_free()
	state_machine.clear_stack({"scene" : last_scene, "from_pause" : true})
	
	if state_machine._push_state(MainMenu):
		return
	pass

func _on_ContinueButton_pressed():
	if state_machine._pop_state({"scene" : last_scene, "from_pause" : true}):
		return
