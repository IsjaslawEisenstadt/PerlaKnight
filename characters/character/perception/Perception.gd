extends Node2D
class_name Perception

onready var Sight: Area2D = $Sight
onready var Host = $"../.."

func get_visible_objects(of_type = Node) -> Array:
	var nodes: Array = []
	
	for body in Sight.get_overlapping_bodies():
		if body is of_type && body != Host:
			nodes.append(body)
	
	for area in Sight.get_overlapping_areas():
		if area is of_type && area != Host:
			nodes.append(area)
	
	return nodes

func get_closest_visible_object(of_type = Node) -> Node:
	var nodes: Array = get_visible_objects(of_type)
	
	if nodes.empty():
		return null
	
	var closest_node: Node = nodes.front()
	var closest_distance: float = Host.global_position.distance_squared_to(closest_node.global_position)
	
	for i in range(1, nodes.size()):
		var next_node: Node = nodes[i]
		var next_distance: float = Host.global_position.distance_squared_to(next_node)
		if next_distance < closest_distance:
			closest_node = next_node
			closest_distance = next_distance
	
	return closest_node

func is_on_wall() -> bool:
	return !$Wall.get_overlapping_bodies().empty()

func is_on_edge() -> bool:
	return $Edge.get_overlapping_bodies().empty()
