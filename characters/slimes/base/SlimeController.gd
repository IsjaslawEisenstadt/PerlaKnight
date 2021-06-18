extends AIController
class_name SlimeController

var can_change_direction: bool = true

func _ready() -> void:
	activate_action("move_left" if randi() % 2 else "move_right")

func _input_process(_delta: float) -> void:
	return
	activate_action("jump")

func _input_physics_process(_delta: float) -> void:
	if Host.is_on_wall() && can_change_direction:
		stop_moving()
		activate_action("move_left" if Host.look_direction == 1 else "move_right")
		
		can_change_direction = false
		yield(get_tree().create_timer(0.2, false), "timeout")
		can_change_direction = true

func stop_moving() -> void:
	deactivate_action("move_left")
	deactivate_action("move_right")
