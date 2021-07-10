extends Sequence
class_name PortalSequence

enum SequenceState {
	WALKING_TO_START,
	WAITING,
	WALKING_INTO_PORTAL,
	ENDING
}

export var waypoint_distance_epsilon: float = 5.0

var portal: Portal
var current_state: int

func _state_enter(_previous_state: State, params: Dictionary = {}) -> void:
	portal = params.object
	
	host.camera.use_custom_target = true
	host.camera.custom_target = portal.CameraPosition.global_position
	host.camera.use_slow_speed = true
	
	input_controller.deactivate_actions()
	var distance: float = host.global_position.x - portal.StartWaypoint.global_position.x
	if abs(distance) > waypoint_distance_epsilon:
		current_state = SequenceState.WALKING_TO_START
		input_controller.activate_action("move_right" if sign(distance) == -1 else "move_left")
	else:
		start_waiting()

func _state_physics_process(_delta: float) -> void:
	if current_state == SequenceState.WALKING_TO_START:
		if abs(host.global_position.x - portal.StartWaypoint.global_position.x) <= waypoint_distance_epsilon:
			input_controller.deactivate_actions()
			start_waiting()
	if current_state == SequenceState.WALKING_INTO_PORTAL:
		if abs(host.global_position.x - portal.EndWaypoint.global_position.x) <= waypoint_distance_epsilon:
			input_controller.deactivate_actions()
			end()

func start_waiting() -> void:
	host.look_direction = 1
	current_state = SequenceState.WAITING
	portal.AnimationPlayer.play("runes")
	yield(portal.AnimationPlayer, "animation_finished")
	portal.AnimationPlayer.play("open")
	yield(portal.AnimationPlayer, "animation_finished")
	portal.AnimationPlayer.play("idle")
	current_state = SequenceState.WALKING_INTO_PORTAL
	input_controller.activate_action("move_right")

func end() -> void:
	current_state = SequenceState.ENDING
	portal.AnimationPlayer.play("close")
	yield(portal.AnimationPlayer, "animation_finished")
	host.emit_signal("end_requested")

func _does_handle(object) -> bool:
	return object is Portal
