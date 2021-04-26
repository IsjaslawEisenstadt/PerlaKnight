extends AI
class_name SearchAI

"""
base state for the AIStateMachine
every AI script has access to the host and input_controller
"""

var follow_state_path: NodePath = "../../FollowAI"
onready var FollowAI:= get_node_or_null(follow_state_path) as AI 

export var player_path: NodePath = "/root/TestLevel/Level1/Characters/Player"
onready var player: Character = get_node(player_path) as Character

export var search_distance = 70
var distance_to_player = 0
	
func _state_process(_delta: float) -> void:
	_searchForPlayer()

func _searchForPlayer():
	distance_to_player = host.position.distance_to(player.position)

	if distance_to_player <= search_distance and not _is_standing_on_edge():
		if state_machine._pop_push(FollowAI, {'player':player, 'search_distance':search_distance}):
			return
			
func is_active() -> bool:
	return state_machine and state_machine.get_current_state() == self

