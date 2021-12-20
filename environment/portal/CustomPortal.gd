extends Interaction
class_name CustomPortal

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

func _interact(character: Player) -> void:
	if character:
		character.start_sequence(self)
	._interact(character)

func _can_interact(_character) -> bool:
	return !$Runes.visible
