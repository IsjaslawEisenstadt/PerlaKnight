extends Area2D
class_name PressurePlate

signal switch_triggered(activated)

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(_body):
	$AnimationPlayer.play("press")
	emit_signal("switch_triggered", true)

func on_body_exited(_body):
	$AnimationPlayer.play_backwards("press")
	emit_signal("switch_triggered", false)
