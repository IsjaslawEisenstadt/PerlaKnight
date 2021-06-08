extends Area2D
class_name Hazard

export var damage: int = 1

func _process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is Character:
			body.hit(self, damage)
