extends AI
class_name SearchAI

onready var FollowAI := get_node_or_null(follow_state_path) as AI

export var follow_state_path: NodePath = "../FollowAI"
export var search_distance: int = 70
export var can_follow = false

var distance_to_player: int = 0
	
func _ready() -> void:
	Perception.connect("body_entered", self, "on_body_perceived")

func on_body_perceived(body) -> void:
	if body is Player && state_machine && can_follow:
		if state_machine._pop_push(FollowAI, { 'player': body }):
			return
