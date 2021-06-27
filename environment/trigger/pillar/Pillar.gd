extends Node2D
class_name Pillar

onready var switch : Area2D = get_node_or_null(switch_path)

export var switch_path : NodePath

func _ready() -> void:
	switch.get_node("Switch").connect("switch_triggered", self, "on_switch_triggered")

func on_switch_triggered(activated) -> void:
	if activated:
		$AnimationPlayer.play("Trigger")
	else:
		$AnimationPlayer.play_backwards("Trigger")
