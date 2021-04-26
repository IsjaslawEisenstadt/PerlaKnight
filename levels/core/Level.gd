extends Node
class_name Level

onready var Player := get_node(player_path) as Player

export var player_path: NodePath = "Level1/Characters/Player"

var screen_space_ui: ScreenSpaceUI
var world_space_ui: WorldSpaceUI

func set_ui(new_screen_space_ui: ScreenSpaceUI, new_world_space_ui: WorldSpaceUI) -> void:
	screen_space_ui = new_screen_space_ui
	world_space_ui = new_world_space_ui
	screen_space_ui.connect_player(Player)
	world_space_ui.connect_player(Player)

func _exit_tree() -> void:
	screen_space_ui.disconnect_player(Player)
	world_space_ui.disconnect_player(Player)
