tool
extends Node2D
class_name Level

enum LevelTypes {
	DUNGEON, FOREST
}

# warning-ignore:unused_signal
signal save_requested()
signal transition_requested(level_name, target_name)

onready var player := get_node_or_null(player_path) as Player
onready var Deer := get_node_or_null(deer_path) as Character
onready var SpawnTargets := get_node(spawn_targets_path)

export var player_path: NodePath
export var deer_path: NodePath = "Characters/Deer"
export var spawn_targets_path: NodePath = "Props"
export var dialogue_triggers: Array

export(LevelTypes) var level_type: int = LevelTypes.DUNGEON

var play_ui: PlayUI

var save_requested: bool = false

func _ready() -> void:
	if !Engine.editor_hint:
		if Deer:
			for trigger_path in dialogue_triggers:
				get_node(trigger_path).deer = Deer
		
		var smart_camera: SmartCamera = preload("res://utility/camera/SmartCamera.tscn").instance()
		smart_camera.player = player
		add_child(smart_camera)

func _process(_delta: float) -> void:
	if save_requested:
		request_save()

func set_ui(play_ui_: PlayUI) -> void:
	play_ui = play_ui_
	play_ui.connect_player(player)

func _exit_tree() -> void:
	if save_requested:
		request_save()
	if play_ui:
		play_ui.disconnect_player(player)

func request_save() -> void:
	save_requested = false
	emit_signal("save_requested")

func on_save_requested() -> void:
	save_requested = true

func on_transition_requested(level_name, target_name) -> void:
	emit_signal("transition_requested", level_name, target_name)

# used by the LDtk importer
func new_entities(new_entity: Array) -> void:
	player_path = ""
	
	if !dialogue_triggers:
		dialogue_triggers = []
	
	for entity in new_entity:
		if entity.has_signal("save_requested"):
			# CONNECT_PERSIST makes sure the signal connection is saved to disk
			entity.connect("save_requested", self, "on_save_requested", [], CONNECT_PERSIST)
		if entity.has_signal("transition_requested"):
			entity.connect("transition_requested", self, "on_transition_requested", [], CONNECT_PERSIST)
		if entity is Player:
			player_path = get_path_to(entity)
		if entity is DialogueSequenceTrigger:
			dialogue_triggers.append(get_path_to(entity))
