extends StaticBody2D
class_name Trigger

export var switch_path : NodePath

onready var switch : Switch = get_node(switch_path) as Switch

func _ready():
	assert(switch is Switch)
	switch.connect("switch_triggered", self, "_on_switch_triggered")

func _on_switch_triggered(activated):
	pass
