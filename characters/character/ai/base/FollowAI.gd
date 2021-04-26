extends AI
class_name FollowAI

"""
base state for the AIStateMachine
every AI script has access to the host and input_controller
"""

var player

var distance_to_player = 0
var search_distance = 0

export var stop_walking_distance = 50

export var idle_state_path: NodePath = "../SearchAI/IdleAI"
onready var IdleAI := get_node_or_null(idle_state_path) as AI

func _ready() -> void:
	WallCollider.connect("body_entered", self, "_on_wall_collision")
	
func _state_enter(_previous_state: State, _params: Dictionary = {}) -> void:
	player = _params['player']
	search_distance = _params['search_distance']
	
func _state_process(_delta: float) -> void:
	distance_to_player = host.position.distance_to(player.position)

	if distance_to_player <= stop_walking_distance || _is_standing_on_edge():
		input_controller.deactivate_action("move_left")
		input_controller.deactivate_action("move_right")
	elif not _is_standing_on_edge():
		if host.position.x <= player.position.x:
			input_controller.activate_action("move_right")
		else:
			input_controller.activate_action("move_left")		
	
	if distance_to_player > search_distance:
		if state_machine._pop_push(IdleAI):
			return

func is_active() -> bool:
	return state_machine && state_machine.get_current_state() == self

func _state_exit(_next_state: State) -> void:
	input_controller.deactivate_actions()
