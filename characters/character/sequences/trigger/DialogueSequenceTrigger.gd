tool
extends SequenceTrigger
class_name DialogueSequenceTrigger

export var player_waypoint: Vector2
export var deer_teleport_waypoint: Vector2
export(String, "Left", "Right", "NoMove") var move_direction := "NoMove"
export var dialogue: Resource

var deer: Character
