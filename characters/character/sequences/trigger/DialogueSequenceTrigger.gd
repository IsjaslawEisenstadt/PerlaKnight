tool
extends SequenceTrigger
class_name DialogueSequenceTrigger

onready var Deer := get_node_or_null(deer_path) as Character

export var deer_path: NodePath
export var player_waypoint: Vector2
export var deer_waypoint: Vector2
export var dialogue: Resource
