tool
extends SequenceTrigger
class_name DialogueSequenceTrigger

export var player_waypoint: Vector2
export var deer_teleport_waypoint: Vector2
export(String, "Left", "Right") var deer_teleport_look_direction: String
export(String, "MoveLeft", "MoveRight", "Wait", "Leave") var end_action := "Wait"
export var dialogue: Resource

var deer: Character
