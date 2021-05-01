extends SearchAI
class_name RoamAI

onready var IdleAI := get_node_or_null(idle_state_path) as AI

export var idle_state_path: NodePath = "../IdleAI"

export var roaming_min_time = 0
export var roaming_max_time = 5

var roaming_timer : Timer
var waiting_for_turn: bool = false

func _ready() -> void:
	roaming_timer = Timer.new()
	roaming_timer.one_shot = true
	add_child(roaming_timer)
	
	roaming_timer.connect("timeout", self, "finished_roaming")

func _state_enter(_previous_state: State, _params: Dictionary = {}) -> void:
	if is_near_wall() || is_standing_on_edge():
		waiting_for_turn = true
		host.connect("character_turned", self, "set", ["waiting_for_turn", true], CONNECT_ONESHOT)
		
	roaming_timer.start(randi() % (roaming_max_time + 1) + roaming_min_time)
	
	if host.look_direction == 1:
		input_controller.activate_action("move_left")
	elif host.look_direction == -1:
		input_controller.activate_action("move_right")
	
func finished_roaming():
	if state_machine._pop_push(IdleAI):
		return

func _state_process(delta: float) -> void:
	._state_process(delta)
	
	if !waiting_for_turn && (is_near_wall() || is_standing_on_edge()):
		roaming_timer.stop()
		finished_roaming()

func _state_exit(_next_state: State) -> void:
	input_controller.deactivate_actions()
	roaming_timer.stop()
	host.disconnect("character_turned", self, "set")
