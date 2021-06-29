extends Sequence
class_name PlayerDialogueSequence

enum DialogueState {
	WALK_TO_WAYPOINT,
	READY_TO_TALK,
	TALK_DELAY,
	TALKING,
}

export var waypoint_distance_epsilon: float = 5.0
export var ready_to_talk_delay: float = 1.0

var sequence_trigger: DialogueSequenceTrigger

var dialogue_state: int

func _ready() -> void:
	pass

func _state_enter(_previous_state: State, params: Dictionary = {}) -> void:
	sequence_trigger = params.object
	
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

func _state_exit(_next_state: State, _params: Dictionary = {}) -> void:
	pass

func _does_handle(object) -> bool:
	return object is DialogueSequenceTrigger
