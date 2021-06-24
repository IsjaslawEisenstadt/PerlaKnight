extends Node2D
class_name Pillar

export var switch_path : NodePath
onready var switch : Area2D = get_node_or_null(switch_path)

func _ready():
	switch.get_node("Switch").connect("switch_triggered", self, "on_switch_triggered")

func on_switch_triggered(activated):
	if activated:
		$AnimationPlayer.play("Trigger")
	else:
		$AnimationPlayer.play_backwards("Trigger")
