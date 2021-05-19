extends Node2D
class_name DoorCast

onready var DoorCastLeft: RayCast2D = $DoorCastLeft
onready var DoorCastRight: RayCast2D = $DoorCastRight
onready var DoorCastTop: RayCast2D = $DoorCastTop
onready var DoorCastBottom: RayCast2D = $DoorCastBottom

func get_doorway() -> Doorway:
	var doorway: Doorway
	if (DoorCastLeft.is_colliding() && DoorCastRight.is_colliding() && 
		DoorCastTop.is_colliding() && DoorCastBottom.is_colliding()):
		doorway = DoorCastLeft.get_collider() as Doorway
	return doorway
