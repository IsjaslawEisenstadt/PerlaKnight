extends Character
class_name Player

signal save_requested()
signal transition_requested(level_name, target_name)

onready var DoorCast: DoorCast = $Colliders/DoorCast
onready var SequenceController: SequenceController = $SequenceController

onready var Runes = []

var closest_interaction: Interaction

var is_in_sequence: bool = false

func _process(_delta: float) -> void:
	if InputController._is_action_just_activated("reset"):
		# a 'default' transition call, this will infer to use checkpoints
		emit_signal("transition_requested", null, null)

	if !is_in_sequence:
		var doorway: Doorway = DoorCast.get_doorway()
		if doorway:
			emit_signal("transition_requested", doorway.next_level, doorway.next_door)
			set_process(false)
			yield(get_tree(), "idle_frame")
			StateMachine.state_stack = []

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

func load_game(save_data: Dictionary, level) -> void:
	if "spawn_target" in save_data:
		start_sequence(level.SpawnTargets.get_node(save_data.spawn_target))
		save_data.erase("spawn_target")
		emit_signal("save_requested")
	elif save_data.get("checkpoint_level") == level.name && "checkpoint_name" in save_data:
		global_position = level.SpawnTargets.get_node(save_data.checkpoint_name).global_position

func _get_input_controller() -> InputController:
	return SequenceController if is_in_sequence else InputController

func start_sequence(object) -> void:
	is_in_sequence = SequenceController.start_sequence(object)
	if is_in_sequence:
		yield(SequenceController, "sequence_finished")
		is_in_sequence = false

func add_rune(rune: Rune) -> void:
	Runes.push_front(rune)
	
	if rune.resource_name == "HealthRune":
		max_health = max_health + 1
		set_current_health(max_health, true)
		print(current_health)

func has_rune(name: String) -> bool:
	for rune in Runes:
		if rune.resource_name == name:
			return true
	return false
