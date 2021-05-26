extends Character
class_name Slime

onready var CollisionShape = $AttackCollider as Area2D

func _ready() -> void:
	assert(CollisionShape)
	CollisionShape.connect("body_entered", self, "on_body_entered")

func on_body_entered(body) -> void:
	if body is Player && current_health > 0:
		body.hit(self, 1)
