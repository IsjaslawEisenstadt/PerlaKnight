extends Character
class_name Player

signal transition_to_checkpoint

onready var Checkpoints := get_node_or_null("../../Checkpoints")
onready var Runes = []

var closest_interaction: Interaction
var current_checkpoint: Checkpoint setget set_current_checkpoint

func _ready():
	for checkpoint in Checkpoints.get_children():
		if checkpoint.default:
			checkpoint._interact(self)
		
	assert(current_checkpoint)

func _process(_delta: float) -> void:
	if InputController._is_action_just_activated("reset"):
		emit_signal("transition_to_checkpoint")

func _interaction_process() -> void:
	if closest_interaction && is_instance_valid(closest_interaction):
		closest_interaction.hide_icons()
	
	closest_interaction = Interactor.get_closest_interaction(self)
	
	if closest_interaction && is_instance_valid(closest_interaction):
			closest_interaction.show_icons()
	
	if (closest_interaction 
		&& InputController._is_action_just_activated("interact") 
		&& StateMachine.get_current_state()._can_interact()):
		
		closest_interaction._interact(self)

func set_current_checkpoint(new_checkpoint: Checkpoint) -> void:
	if new_checkpoint != current_checkpoint:
		if current_checkpoint:
			current_checkpoint.deactivate()
		current_checkpoint = new_checkpoint

func reset() -> void:
	self.position = current_checkpoint.last_position
