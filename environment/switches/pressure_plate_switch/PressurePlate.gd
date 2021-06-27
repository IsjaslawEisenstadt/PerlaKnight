extends Area2D
class_name PressurePlate

signal switch_triggered(activated)

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(_body) -> void:
	$AnimationPlayer.play("press")
	$Switch.trigger(true)

func on_body_exited(_body) -> void:
	$AnimationPlayer.play_backwards("press")
	$Switch.trigger(false)
