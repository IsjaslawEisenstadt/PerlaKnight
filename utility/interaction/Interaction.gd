extends Node2D
class_name Interaction

signal interacted(interaction, with)

onready var IconPosition := $IconPosition

func _interact(character) -> void:
	emit_signal("interacted", self, character)

func _can_interact(_character) -> bool:
	return true
