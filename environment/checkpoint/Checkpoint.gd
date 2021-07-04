tool
extends Interaction
class_name Checkpoint

signal save_requested()
signal save_to_file_requested()

onready var AnimationPlayer := $AnimationPlayer

var active: bool = false setget set_active

func _interact(_character) -> void:
	activate()
	emit_signal("save_to_file_requested")

func _can_interact(_character) -> bool:
	return true

func activate() -> void:
	if !active:
		self.active = true
		AnimationPlayer.play("activate")
		$Activate._play()

func activate_immediately(override: bool = false) -> void:
	set_active(true, override)
	AnimationPlayer.play("activate")
	AnimationPlayer.advance(AnimationPlayer.get_animation("activate").length)

func deactivate() -> void:
	self.active = false
	if AnimationPlayer.current_animation_position != 0:
		AnimationPlayer.play_backwards("activate")
		AnimationPlayer.seek(AnimationPlayer.current_animation_position, true)

func set_active(new_active: bool, override: bool = false) -> void:
	if active != new_active:
		active = new_active
		if active:
			for checkpoint in get_tree().get_nodes_in_group("Checkpoint"):
				if checkpoint != self:
					assert("active" in checkpoint)
					if checkpoint.active:
						checkpoint.deactivate()
			if !override:
				emit_signal("save_requested")

func save_game(save_data: Dictionary, level) -> void:
	if active:
		save_data["checkpoint_level"] = level.name
		save_data["checkpoint_name"] = name

func load_game(save_data: Dictionary, level) -> void:
	if save_data.get("checkpoint_level") == level.name && save_data.get("checkpoint_name") == name:
		activate_immediately(true)
