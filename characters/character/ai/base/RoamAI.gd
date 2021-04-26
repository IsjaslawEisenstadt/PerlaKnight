extends SearchAI
class_name RoamAI

"""
base state for the AIStateMachine
every AI script has access to the host and input_controller
"""

const DIRECTION_LEFT = -1
const DIRECTION_RIGHT = 1
var direction = DIRECTION_LEFT

var roaming_timer : Timer
export var roaming_min_time = 0
export var roaming_max_time = 5

export var idle_state_path: NodePath = "../IdleAI"
onready var IdleAI := get_node_or_null(idle_state_path) as AI

func _ready() -> void:
	roaming_timer = Timer.new()
	roaming_timer.one_shot = true
	add_child(roaming_timer)
	
	roaming_timer.connect("timeout", self, "finished_roaming")
	WallCollider.connect("body_entered", self, "_on_wall_collision")

func _state_enter(_previous_state: State, _params: Dictionary = {}) -> void:
	roaming_timer.start(randi() % (roaming_max_time+1) + roaming_min_time)
	
	if direction == DIRECTION_LEFT:
		input_controller.activate_action("move_left")
	elif direction == DIRECTION_RIGHT:
		input_controller.activate_action("move_right")
	
func finished_roaming():
	host.set_look_direction(direction*-1)
	
	if state_machine._pop_push(IdleAI):
		return

func _state_process(_delta: float) -> void:
	
	if _is_standing_on_edge():
		roaming_timer.stop()
		finished_roaming()
		
	._state_process(_delta)

func _state_exit(_next_state: State) -> void:
	if direction == DIRECTION_LEFT:
		input_controller.deactivate_action("move_left")
		direction = DIRECTION_RIGHT
	elif direction == DIRECTION_RIGHT:
		input_controller.deactivate_action("move_right")
		direction = DIRECTION_LEFT
		
	roaming_timer.stop()

func is_active() -> bool:
	return state_machine and state_machine.get_current_state() == self
	
func _on_wall_collision(body: Node) -> void:
	if body is StaticBody2D:
		roaming_timer.stop()
		finished_roaming()
