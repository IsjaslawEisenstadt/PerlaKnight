tool
extends Node2D
class_name Level

# warning-ignore:unused_signal
signal save_requested()

onready var player := get_node(player_path) as Player

export var player_path: NodePath

var play_ui: PlayUI

func _ready() -> void:
	if player:
		var smart_camera: SmartCamera = preload("res://utility/camera/SmartCamera.tscn").instance()
		smart_camera.player = player
		add_child(smart_camera)

func set_ui(play_ui_: PlayUI) -> void:
	play_ui = play_ui_
	play_ui.connect_player(player)

func _exit_tree() -> void:
	if play_ui:
		play_ui.disconnect_player(player)

func save_game(save_data: Dictionary) -> void:
	player.save_game(save_data)

func load_game(save_data: Dictionary) -> void:
	player.load_game(save_data)

# used by the LDtk importer
func new_entities(new_entity: Array) -> void:
	player_path = ""
	for entity in new_entity:
		if entity.has_signal("save_requested"):
			# CONNECT_PERSIST makes sure the signal connection is saved to disk
			entity.connect("save_requested", self, "emit_signal", ["save_requested"], CONNECT_PERSIST)
		if entity is Player:
			player_path = get_path_to(entity)
