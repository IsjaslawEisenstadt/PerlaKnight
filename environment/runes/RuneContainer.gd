extends Interaction
class_name Rune

export(Resource) var rune_resource
export(String) var rune_resource_path

func _ready():
	rune_resource = load(rune_resource_path)
	$Sprite.texture = rune_resource.texture 

func _interact(character) -> void:
	character.Runes.push_front(rune_resource)
	
	queue_free()
