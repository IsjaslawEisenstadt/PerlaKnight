tool
extends Area2D
class_name SequenceTrigger

export var shape: Vector2 setget set_shape

var is_active: bool = true

func _ready() -> void:
	if !Engine.editor_hint:
		connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Player) -> void:
	if body && is_active:
		is_active = false
		body.start_sequence(self)

func set_shape(new_shape: Vector2) -> void:
	shape = new_shape
	var collision_shape := $CollisionShape2D.shape as RectangleShape2D
	if collision_shape:
		collision_shape.extents = shape / 2
		$CollisionShape2D.position = shape / 2
