extends AIController
class_name SequenceController

signal sequence_finished()

var is_sequence_running: bool = false

var state_machine: SequenceStateMachine

func _ready() -> void:
	state_machine = SequenceStateMachine.new()
	state_machine.host = Host
	state_machine.input_controller = self

func start_sequence(object) -> bool:
	for sequence in get_children():
		assert(sequence is Sequence)
		if sequence._does_handle(object):
			if state_machine._push_state(sequence, {"object": object}):
				is_sequence_running = true
				return true
	return false

func _process(delta: float) -> void:
	if is_sequence_running && !state_machine.get_current_state():
		is_sequence_running = false
		emit_signal("sequence_finished")
	
	state_machine._state_machine_process(delta)

func _physics_process(delta: float) -> void:
	state_machine._state_machine_physics_process(delta)

func _should_auto_start() -> bool:
	return false
