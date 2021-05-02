extends Character
class_name Player

signal transition_to_checkpoint

var current_checkpoint: Checkpoint setget set_current_checkpoint

func _process(_delta: float) -> void:
	if InputController._is_action_just_activated("reset"):
		emit_signal("transition_to_checkpoint")

func set_current_checkpoint(new_checkpoint: Checkpoint) -> void:
	if new_checkpoint != current_checkpoint:
		if current_checkpoint:
			current_checkpoint.deactivate()
		current_checkpoint = new_checkpoint
		current_checkpoint.activate()

func reset() -> void:
	self.position = current_checkpoint.last_position
