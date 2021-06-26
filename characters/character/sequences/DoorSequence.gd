extends Sequence
class_name DoorSequence

onready var DoorSequenceRange := get_node(door_sequence_range_path) as Area2D

export var door_sequence_range_path: NodePath = "../../Colliders/DoorSequenceRange"

var input_timer := Timer.new()
var input_delay_timer := Timer.new()

func _ready() -> void:
	input_timer.one_shot = true
	input_delay_timer.one_shot = true
	add_child(input_timer)
	add_child(input_delay_timer)

func _state_enter(_previous_state: State, params: Dictionary = {}) -> void:
	assert("object" in params && params.object is Doorway)
	
	host.global_position = params.object.SpawnPosition.global_position
	
	var horizontal: bool = false
	var input_wait_time: float = 0.1
	
	match params.object.exit_direction:
		"UpLeft", "UpRight":
			host.velocity.y = -455
			input_wait_time = 0.35
			input_delay_timer.start(0.15)
			continue # fallthrough
		"Left", "UpLeft":
			host.look_direction = -1
			horizontal = true
		"Right", "UpRight": 
			host.look_direction = 1
			horizontal = true
	
	input_timer.start(input_wait_time)
	
	if !input_delay_timer.is_stopped():
		yield(input_delay_timer, "timeout")
	
	if horizontal:
		input_controller.activate_action("move_right" if host.look_direction == 1 else "move_left")

func _state_process(_delta: float) -> void:
	if input_timer.is_stopped() && DoorSequenceRange.get_overlapping_areas().empty():
		state_machine._pop_state()

func _state_exit(_next_state: State, _params: Dictionary = {}) -> void:
	input_controller.deactivate_actions()

func _does_handle(object) -> bool:
	return object is Doorway
