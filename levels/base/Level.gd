tool
extends Node2D
class_name Level

# warning-ignore:unused_signal
signal save_requested()
signal transition_requested(level_path, target_name)

onready var player := get_node(player_path) as Player

export var player_path: NodePath

var play_ui: PlayUI

func _ready() -> void:
	if player && !Engine.editor_hint:
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
	if "spawn_target" in save_data:
		save_data.spawn_target = get_node(save_data.spawn_target)
	player.load_game(save_data)

func on_transition_requested(level_path, target_name) -> void:
	emit_signal("transition_requested", level_path, target_name)

# used by the LDtk importer
func new_entities(new_entity: Array) -> void:
	player_path = ""
	for entity in new_entity:
		if entity.has_signal("save_requested"):
			# CONNECT_PERSIST makes sure the signal connection is saved to disk
			entity.connect("save_requested", self, "emit_signal", ["save_requested"], CONNECT_PERSIST)
		if entity.has_signal("transition_requested"):
			entity.connect("transition_requested", self, "on_transition_requested", [], CONNECT_PERSIST)
		if entity is Player:
			player_path = get_path_to(entity)
