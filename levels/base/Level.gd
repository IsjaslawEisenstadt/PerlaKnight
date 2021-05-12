tool
extends Node2D
class_name Level

onready var player := get_node(player_path) as Player

export var player_path: NodePath
export(Array, NodePath) var checkpoint_paths := [] 

var play_ui: PlayUI

func set_ui(play_ui_: PlayUI) -> void:
	play_ui = play_ui_
	play_ui.connect_player(player)

func _exit_tree() -> void:
	if play_ui:
		play_ui.disconnect_player(player)

func save(save_data: Dictionary) -> void:
	player.save(save_data)

func load_game(save_data: Dictionary) -> void:
	player.load_game(save_data)

# used by the LDtk importer
func new_entities(new_entity: Array) -> void:
	player_path = ""
	checkpoint_paths.clear()
	
	for entity in new_entity:
		if entity is Player:
			player_path = get_path_to(entity)
		elif entity is Checkpoint:
			checkpoint_paths.append(get_path_to(entity))
