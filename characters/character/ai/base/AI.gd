extends State
class_name AI

"""
base state for the AIStateMachine
every AI script has access to the host and input_controller
"""
onready var EdgeCollider = get_node(edge_collider_path) as Area2D
onready var WallCollider = get_node(wall_collider_path) as Area2D
onready var Perception := get_node(perception_path) as Area2D

export var edge_collider_path: NodePath = "../../EdgeCollider"
export var wall_collider_path: NodePath = "../../WallCollider"
export var perception_path: NodePath = "../../Perception"

#warning-ignore:unused_class_variable
var host: Character
#warning-ignore:unused_class_variable
var input_controller: AIInputController

func is_standing_on_edge() -> bool:
	return EdgeCollider.get_overlapping_bodies().empty()

func is_near_wall() -> bool:
	return !WallCollider.get_overlapping_bodies().empty()
