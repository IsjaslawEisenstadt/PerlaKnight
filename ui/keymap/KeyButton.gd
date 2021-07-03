tool
extends Control

export var text: String = "" setget set_text

func set_text(new_text: String) -> void:
	text = new_text
	if has_node("Label"):
		$Label.text = text
