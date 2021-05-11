extends Interaction
class_name Rune

export(Resource) var rune_ressource

func _ready():
	rune_ressource.texture = $Sprite.texture

func _interact(character) -> void:
	character.Runes.push_front(rune_ressource)
	
	queue_free()
