tool
extends Node2D
class_name Interaction

signal interacted(interaction, with)

onready var Icons := $Sprite/Icons
onready var IconAnimator := $IconAnimator

func _ready() -> void:
	if !Engine.editor_hint:
		Icons.visible = false
	IconAnimator.play("bounce")

func _interact(character) -> void:
	emit_signal("interacted", self, character)

func _can_interact(_character) -> bool:
	return true

func show_icons() -> void:
	Icons.visible = true

func hide_icons() -> void:
	Icons.visible = false
