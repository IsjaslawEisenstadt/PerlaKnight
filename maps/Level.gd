tool
extends Node2D
class_name Level

enum LevelTypes {
	DUNGEON, FOREST
}

signal save_requested()
signal save_to_file_requested()
signal transition_requested(level_name, target_name)
signal preload_requested(level_name)
signal restore_requested()
signal end_requested()

onready var Player_ := get_node_or_null(player_path) as Player
onready var Deer := get_node_or_null(deer_path) as Character
onready var SpawnTargets := get_node(spawn_targets_path)

export var player_path: NodePath
export var deer_path: NodePath = "Characters/Deer"
export var spawn_targets_path: NodePath = "Props"
export var dialogue_triggers: Array

export(LevelTypes) var level_type: int = LevelTypes.DUNGEON

var play_ui: PlayUI

func _ready() -> void:
	if !Engine.editor_hint:
		if !is_in_group("Persistent"):
			add_to_group("Persistent")
		
		if Deer:
			for trigger_path in dialogue_triggers:
				get_node(trigger_path).deer = Deer
		
		var smart_camera: SmartCamera = preload("res://utility/camera/SmartCamera.tscn").instance()
		smart_camera.player = Player_
		add_child(smart_camera)
		
		#call_deferred("on_save_requested")

func set_ui(new_play_ui: PlayUI) -> void:
	play_ui = new_play_ui
	play_ui.connect_player(Player_)

func _exit_tree() -> void:
	if play_ui:
		play_ui.disconnect_player(Player_)

func preload_level(level_name: String) -> void:
	emit_signal("preload_requested", level_name)

func save_game(save_data: Dictionary, _level) -> void:
	if level_type == LevelTypes.FOREST:
		save_data["tutorial_level"] = name
	else:
		save_data.erase("tutorial_level")

func on_save_requested() -> void:
	emit_signal("save_requested")

func on_save_to_file_requested() -> void:
	emit_signal("save_to_file_requested")

func on_transition_requested(level_name, target_name) -> void:
	emit_signal("transition_requested", level_name, target_name)

func on_restore_requested() -> void:
	emit_signal("restore_requested")
	
func on_end_requested() -> void:
	emit_signal("end_requested")

# used by the LDtk importer
func new_entities(new_entity: Array) -> void:
	player_path = ""
	
	if !dialogue_triggers:
		dialogue_triggers = []
	
	for entity in new_entity:
		if entity.has_signal("save_requested"):
			# CONNECT_PERSIST makes sure the signal connection is saved to disk
			entity.connect("save_requested", self, "on_save_requested", [], CONNECT_PERSIST)
		if entity.has_signal("save_to_file_requested"):
			# CONNECT_PERSIST makes sure the signal connection is saved to disk
			entity.connect("save_to_file_requested", self, "on_save_to_file_requested", [], CONNECT_PERSIST)
		if entity.has_signal("transition_requested"):
			entity.connect("transition_requested", self, "on_transition_requested", [], CONNECT_PERSIST)
		if entity.has_signal("restore_requested"):
			entity.connect("restore_requested", self, "on_restore_requested", [], CONNECT_PERSIST)
		if entity.has_signal("end_requested"):
			entity.connect("end_requested", self, "on_end_requested", [], CONNECT_PERSIST)
		if entity is Player:
			player_path = get_path_to(entity)
		if entity is DialogueSequenceTrigger:
			dialogue_triggers.append(get_path_to(entity))
