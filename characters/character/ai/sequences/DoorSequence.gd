extends Sequence
class_name DoorSequence

onready var DoorSequenceRange := get_node(door_sequence_range_path) as Area2D

export var door_sequence_range_path: NodePath = "../../Colliders/DoorSequenceRange"

var timer = Timer.new()

func _state_enter(_previous_state: State, params: Dictionary = {}) -> void:
	assert("object" in params && params.object is Doorway)
	
	host.global_position = params.object.SpawnPosition.global_position
	host.look_direction = params.object.exit_direction
	input_controller.activate_action("move_right" if host.look_direction == 1 else "move_left")
	
	timer.one_shot = true
	add_child(timer)
	timer.start(0.1)

func _state_process(_delta: float) -> void:
	if timer.is_stopped() && DoorSequenceRange.get_overlapping_areas().empty():
		state_machine._pop_state()

func _state_exit(_next_state: State) -> void:
	input_controller.deactivate_actions()

func _does_handle(object) -> bool:
	return object is Doorway
