extends Node2D
class_name Portal

onready var StartWaypoint := $StartWaypoint
onready var EndWaypoint := $EndWaypoint
onready var CameraPosition := $CameraPosition
onready var AnimationPlayer := $AnimationPlayer

func _ready() -> void:
	$PortalBackground.visible = false
	$PortalForeground.visible = false
	$PortalOpening.visible = false
	$Runes.visible = false
	$PlayerMask.visible = false

func on_interacted(interaction: Interaction, with: Player) -> void:
	if with:
		with.start_sequence(self)
