extends AI
class_name FollowAI

onready var IdleAI := get_node_or_null(idle_state_path) as AI

export var idle_state_path: NodePath = "../IdleAI"
export var stop_follow_distance: int = 30

var player: Player
var distance_to_player: int = 0

func _ready() -> void:
	Perception.connect("body_exited", self, "on_perception_exited")

func _state_enter(_previous_state: State, params: Dictionary = {}) -> void:
	player = params['player']
	
func _state_process(_delta: float) -> void:
	distance_to_player = host.position.distance_to(player.position)

	if distance_to_player <= stop_follow_distance || is_standing_on_edge():
		input_controller.deactivate_actions()
	elif !is_standing_on_edge():
		if host.position.x <= player.position.x:
			input_controller.activate_action("move_right")
		else:
			input_controller.activate_action("move_left")

func on_perception_exited(body) -> void:
	if body is Player:
		if state_machine._pop_push(IdleAI):
			return

func _state_exit(_next_state: State) -> void:
	input_controller.deactivate_actions()
