extends SearchAI
class_name IdleAI

onready var RoamAI := get_node_or_null(roam_state_path) as AI

export var roam_state_path: NodePath = "../RoamAI"

export var idling_min_time: int = 0
export var idling_max_time: int = 3

var idle_timer: Timer

func _state_enter(_previous_state: State, _params: Dictionary = {}) -> void:
	idle_timer = Timer.new()
	idle_timer.one_shot = true
	add_child(idle_timer)
	idle_timer.connect("timeout", state_machine, "_pop_push", [RoamAI])
	idle_timer.start(randi() % (idling_max_time+1) + idling_min_time)
