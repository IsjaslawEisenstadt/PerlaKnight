tool
extends Node2D
class_name Level

# warning-ignore:unused_signal
signal save_requested()
signal transition_requested(level_name, target_name)

onready var player := get_node_or_null(player_path) as Player
onready var SpawnTargets := get_node(spawn_targets_path)

export var player_path: NodePath
export var spawn_targets_path: NodePath = "SpawnTargets"

var play_ui: PlayUI

func _ready() -> void:
	if !Engine.editor_hint:
		var smart_camera: SmartCamera = preload("res://utility/camera/SmartCamera.tscn").instance()
		smart_camera.player = player
		add_child(smart_camera)

func set_ui(play_ui_: PlayUI) -> void:
	play_ui = play_ui_
	play_ui.connect_player(player)

func _exit_tree() -> void:
	if play_ui:
		play_ui.disconnect_player(player)

func on_transition_requested(level_name, target_name) -> void:
	emit_signal("transition_requested", level_name, target_name)

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
