extends Node
class_name Level

onready var Player := get_node(player_path) as Player

export var player_path: NodePath = "Level1/Characters/Player"

var play_ui: PlayUI

func set_ui(play_ui_: PlayUI) -> void:
	play_ui = play_ui_
	play_ui.connect_player(Player)

func _exit_tree() -> void:
	play_ui.disconnect_player(Player)
