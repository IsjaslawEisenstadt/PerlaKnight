extends Interaction
class_name Rune

export(Resource) var rune_ressource

func _ready():
	$Sprite.texture = rune_ressource.texture 

func _interact(character) -> void:
	character.Runes.push_front(rune_ressource)
	
	queue_free()
