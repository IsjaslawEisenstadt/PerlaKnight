extends Node
class_name Switch

signal switch_triggered(activated)

var activated = false

func trigger(activated) -> void:
	emit_signal("switch_triggered", activated)
	activated = activated
