extends Area2D
class_name Hazard

export var damage: int = 1

func on_body_entered(body):
	if body is Character:
		body.current_health -= damage
