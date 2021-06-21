extends StaticBody2D
class_name Trigger

export var switch_path : NodePath

onready var switch : Area2D = get_node(switch_path)

func _ready():
	switch.connect("switch_triggered", self, "_on_switch_triggered")

func _on_switch_triggered(_activated):
	pass
