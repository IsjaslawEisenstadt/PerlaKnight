extends AI
class_name RoamAI

"""
base state for the AIStateMachine
every AI script has access to the host and input_controller
"""

const DIRECTION_LEFT = 0;
const DIRECTION_RIGHT = 1;
var direction = DIRECTION_LEFT;

var roaming_timer : Timer;
export var roaming_min_time = 0;
export var roaming_max_time = 5;

onready var EdgeCollider = get_node("../../EdgeCollider") as Area2D;
onready var WallCollider = get_node("../../WallCollider") as Area2D;


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
	if direction == DIRECTION_LEFT:
		input_controller.deactivate_action("move_left")
		direction = DIRECTION_RIGHT
	elif direction == DIRECTION_RIGHT:
		input_controller.deactivate_action("move_right")
		direction = DIRECTION_LEFT
		
	if state_machine._pop_push(IdleAI):
		return

func _state_process(_delta: float) -> void:
	if _is_standing_on_edge():
		roaming_timer.stop()
		finished_roaming()

func _state_physics_process(_delta: float) -> void:
	pass

func _state_exit(_next_state: State) -> void:
	pass

func _can_enter() -> bool:
	return true

func is_active() -> bool:
	return state_machine && state_machine.get_current_state() == self
	
func _on_wall_collision(body: Node):
	if body is StaticBody2D:
		roaming_timer.stop()
		finished_roaming()

func _is_standing_on_edge():
	return EdgeCollider.get_overlapping_bodies().size() == 0
