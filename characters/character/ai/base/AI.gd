extends State
class_name AI

"""
base state for the AIStateMachine
every AI script has access to the host and input_controller
"""
onready var EdgeCollider = get_node_or_null(edge_collider_path) as Area2D
onready var WallCollider = get_node_or_null(wall_collider_path) as Area2D
onready var Perception := get_node_or_null(perception_path) as Area2D

export var edge_collider_path: NodePath = "../../EdgeCollider"
export var wall_collider_path: NodePath = "../../WallCollider"
export var perception_path: NodePath = "../../Perception"

#warning-ignore:unused_class_variable
var host: Character
#warning-ignore:unused_class_variable
var input_controller: AIController

func is_standing_on_edge() -> bool:
	assert(EdgeCollider)
	return EdgeCollider.get_overlapping_bodies().empty()

func is_near_wall() -> bool:
	assert(WallCollider)
	return !WallCollider.get_overlapping_bodies().empty()
