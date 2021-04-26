extends State
class_name AI

"""
base state for the AIStateMachine
every AI script has access to the host and input_controller
"""

#warning-ignore:unused_class_variable
var host: Character
#warning-ignore:unused_class_variable
var input_controller: AIInputController

export var edge_collider_path: NodePath = "../../../EdgeCollider"
onready var EdgeCollider = get_node(edge_collider_path) as Area2D

export var wall_collider_path: NodePath = "../../../WallCollider"
onready var WallCollider = get_node(wall_collider_path) as Area2D

func _is_standing_on_edge() -> bool:
	for body in EdgeCollider.get_overlapping_bodies():
		if body is StaticBody2D:
			return false

	return true
