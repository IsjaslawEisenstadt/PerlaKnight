extends Area2D
class_name Interactor

func get_closest_interaction(character) -> Interaction:
	var closest: Interaction = null
	var dist: float = -1.0
	var areas: Array = get_overlapping_areas()
	if !areas.empty():
		for area in areas:
			if area is Interaction && area._can_interact(character):
				# we can use length squared because we just compare the lengths with each other
				# this is beneficial because length squared is faster (no sqrt)
				var next_dist: float = (global_position - area.global_position).length_squared()
				if dist == -1.0 || next_dist < dist:
					closest = area
					dist = next_dist
	return closest
