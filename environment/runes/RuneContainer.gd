tool
extends Interaction
class_name Rune

export var rune_resource: Resource

func _ready():
	if rune_resource:
		$Sprite.texture = rune_resource.texture 

func _interact(character) -> void:
	character.Runes.push_front(rune_resource)
	queue_free()
