extends AIController
class_name SequenceController

signal sequence_finished()

var is_sequence_running: bool = false

func start_sequence(object) -> bool:
	for sequence in get_children():
		assert(sequence is Sequence)
		if sequence._does_handle(object):
			if state_machine._push_state(sequence, {"object": object}):
				is_sequence_running = true
				return true
	return false

func _process(_delta: float) -> void:
	if is_sequence_running && !state_machine.get_current_state():
		is_sequence_running = false
		emit_signal("sequence_finished")

func _should_auto_start() -> bool:
	return false
