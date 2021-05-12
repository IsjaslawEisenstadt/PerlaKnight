extends Character
class_name Player

signal transition_to_checkpoint()
signal save_requested()

var closest_interaction: Interaction
var current_checkpoint: Checkpoint setget set_current_checkpoint

func _process(_delta: float) -> void:
	if InputController._is_action_just_activated("reset"):
		emit_signal("transition_to_checkpoint")

func _interaction_process() -> void:
	closest_interaction = null
	if StateMachine.get_current_state()._can_interact() && InteractionRay.is_colliding():
		var interaction := InteractionRay.get_collider()
		if interaction is Interaction && interaction._can_interact(self):
			closest_interaction = interaction
			if InputController._is_action_just_activated("interact"):
				closest_interaction._interact(self)

func set_current_checkpoint(new_checkpoint: Checkpoint) -> void:
	if new_checkpoint != current_checkpoint:
		if current_checkpoint:
			current_checkpoint.deactivate()
		current_checkpoint = new_checkpoint
		emit_signal("save_requested")

func reset() -> void:
	self.position = current_checkpoint.global_position

func save_game(save_data: Dictionary) -> void:
	if current_checkpoint:
		save_data["player_checkpoint_path"] = get_path_to(current_checkpoint)

func load_game(save_data: Dictionary) -> void:
	var checkpoint := get_node_or_null(save_data.get("player_checkpoint_path", "")) as Checkpoint
	if checkpoint:
		checkpoint._interact(self)
		reset()
