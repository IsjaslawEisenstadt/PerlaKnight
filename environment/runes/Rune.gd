extends Interaction
class_name Rune

var interactable = true

func _interact(character) -> void:
	character.Runes.push_front(self)
	
	visible = false
	interactable = false
	pass

func _can_interact(_character) -> bool:
	return interactable
