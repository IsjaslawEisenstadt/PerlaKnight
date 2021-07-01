extends Sequence
class_name DeerDialogueSequence

signal walk_finished()

onready var Visibility := get_node(visibility_path) as VisibilityNotifier2D

export var visibility_path: NodePath = "../../VisibilityNotifier2D"

var sequence_trigger: DialogueSequenceTrigger

func _state_enter(_previous_state: State, params: Dictionary = {}) -> void:
	sequence_trigger = params.object
	
	input_controller.deactivate_actions()
	
	if sequence_trigger.end_action.begins_with("Move"):
		input_controller.activate_action("move_right" if sequence_trigger.end_action == "MoveRight" else "move_left")
	elif sequence_trigger.end_action == "Wait":
		call_deferred("emit_signal", "walk_finished")

func _state_physics_process(_delta: float) -> void:
	if !Visibility.is_on_screen():
		
		if sequence_trigger.end_action != "NoMove":
			emit_signal("walk_finished")
		
		input_controller.deactivate_actions()
		teleport()
		state_machine._pop_state()

func teleport() -> void:
	host.global_position = sequence_trigger.deer_teleport_waypoint
	host.look_direction = -1 if sequence_trigger.deer_teleport_look_direction == "Left" else 1

func _does_handle(object) -> bool:
	return object is DialogueSequenceTrigger
