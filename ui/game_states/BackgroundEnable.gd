tool
extends Node

export var visible: bool = true setget set_visible

func set_visible(new_visible: bool) -> void:
	visible = new_visible
	for child in get_children():
		if "visible" in child:
			child.visible = visible
