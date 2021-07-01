extends Sequence
class_name PlayerDialogueSequence

enum DialogueState {
	WALK_TO_WAYPOINT,
	READY_TO_TALK,
	TALK_DELAY,
	TALKING,
}

const DialogueBox := preload("res://ui/dialogue/DialogueBox.tscn")

export var waypoint_distance_epsilon: float = 5.0
export var ready_to_talk_delay: float = 0.5

var sequence_trigger: DialogueSequenceTrigger
var dialogue_state: int
var current_line_index: int

func _state_enter(_previous_state: State, params: Dictionary = {}) -> void:
	sequence_trigger = params.object
	current_line_index = -1
	dialogue_state = -1
	
	if sequence_trigger.deer:
		host.camera.use_custom_target = true
		host.camera.custom_target = sequence_trigger.player_waypoint.linear_interpolate(sequence_trigger.deer.global_position, 0.5)
		host.camera.use_slow_speed = true
	
	input_controller.deactivate_actions()
	var waypoint_distance = host.global_position.x - sequence_trigger.player_waypoint.x
	if abs(waypoint_distance) > waypoint_distance_epsilon:
		input_controller.activate_action("move_right" if sign(waypoint_distance) == -1 else "move_left")
		dialogue_state = DialogueState.WALK_TO_WAYPOINT
	else:
		dialogue_state = DialogueState.READY_TO_TALK

func _state_physics_process(_delta: float) -> void:
	if dialogue_state == DialogueState.WALK_TO_WAYPOINT:
		if abs(host.global_position.x - sequence_trigger.player_waypoint.x) < waypoint_distance_epsilon:
			input_controller.deactivate_actions()
			dialogue_state = DialogueState.READY_TO_TALK
	if dialogue_state == DialogueState.READY_TO_TALK:
		dialogue_state = DialogueState.TALK_DELAY
		yield(get_tree().create_timer(ready_to_talk_delay, false), "timeout")
		dialogue_state = DialogueState.TALKING
		
		on_line_finished()

func on_line_finished(dialogue_box: DialogueBox = null) -> void:
	
	if dialogue_box:
		dialogue_box.get_parent().remove_child(dialogue_box)
		dialogue_box.queue_free()
	
	current_line_index += 1
	if current_line_index < sequence_trigger.dialogue.lines.size():
		
		var current_line: String = sequence_trigger.dialogue.lines[current_line_index]
		
		assert(current_line[0] == '[' && current_line[2] == ']')
		assert(current_line[1] == 'D' || current_line[1] == 'P')
		
		dialogue_box = DialogueBox.instance()
		var character = current_line[1]
		if character == 'P':
			host.DialogueBoxPosition.add_child(dialogue_box)
		else:
			assert(sequence_trigger.deer)
			sequence_trigger.deer.DialogueBoxPosition.add_child(dialogue_box)
		
		dialogue_box.connect("line_finished", self, "on_line_finished", [dialogue_box])
		dialogue_box.text = current_line
	elif sequence_trigger.deer:
		if sequence_trigger.end_action == "Leave":
			host.emit_signal("restore_requested")
		else:
			sequence_trigger.deer.start_sequence(sequence_trigger)
			sequence_trigger.deer.SequenceController_.state_machine.get_current_state().connect("walk_finished", self, "on_walk_finished", [], CONNECT_ONESHOT)
			host.camera.connect("interp_finished", self, "on_interp_finished", [], CONNECT_ONESHOT)
			host.camera.custom_target = host
			host.camera.use_slow_speed = false
	else:
		host.camera.connect("interp_finished", host.camera, "set", ["use_custom_target", false])
		on_walk_finished()

func on_walk_finished() -> void:
	if state_machine.get_current_state() == self:
		if host.camera.use_custom_target:
			yield(host.camera, "interp_finished")
		state_machine._pop_state()

func on_interp_finished() -> void:
	host.camera.use_custom_target = false

func _does_handle(object) -> bool:
	return object is DialogueSequenceTrigger
