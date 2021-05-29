tool
extends TextureRect
class_name RuneEntry

export var rune: Resource setget set_rune

func set_rune(new_rune: Resource) -> void:
	rune = new_rune
	if rune:
		texture = rune.texture
