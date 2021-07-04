tool
extends Node

export var _visible: bool = true setget _set_visible

func _set_visible(new_visible: bool) -> void:
	_visible = new_visible
	for child in get_children():
		if "visible" in child:
			child.visible = _visible
