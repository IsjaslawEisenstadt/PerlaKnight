extends Menu

"""
The start/main menu script that connects the buttons with its corresponding menus.
"""

onready var LoadingScreen := get_node_or_null(loading_screen_path) as Menu

export var loading_screen_path: NodePath = "../LoadingScreen"

export(String, FILE, "*.tscn,*.scn,*.ldtk") var new_game_scene_path: String

func _on_NewGameButton_pressed() -> void:
	state_machine._pop_push(LoadingScreen, { "scene_path": new_game_scene_path })

func _on_ExitButton_pressed() -> void:
	get_tree().quit()
