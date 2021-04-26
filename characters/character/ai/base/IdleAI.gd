extends SearchAI
class_name IdleAI

"""
base state for the AIStateMachine
every AI script has access to the host and input_controller
"""

export var idling_min_time = 0
export var idling_max_time = 3

export var roam_state_path: NodePath = "../RoamAI"

onready var RoamAI := get_node_or_null(roam_state_path) as AI

var idle_timer : Timer

func _state_enter(_previous_state: State, _params: Dictionary = {}) -> void:
	idle_timer = Timer.new()
	add_child(idle_timer)
	idle_timer.one_shot = true
	idle_timer.connect("timeout", self, "finished_idling")
	idle_timer.start(randi() % (idling_max_time+1) + idling_min_time)

func finished_idling():
	if state_machine._pop_push(RoamAI):
		return

func _state_process(_delta: float) -> void:
	._state_process(_delta)

func _state_exit(_next_state: State) -> void:
	idle_timer.stop()

func is_active() -> bool:
	return state_machine && state_machine.get_current_state() == self
