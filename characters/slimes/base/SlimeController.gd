extends AIController
class_name SlimeController

export var backoff_distance: float = 15.0

export var jump_interval: float = 1.3
export var jump_deviation: float = 0.5

var can_change_direction: bool = true
var can_jump: bool = true

func _ready() -> void:
	activate_action("move_left" if randi() % 2 else "move_right")

func _input_process(delta: float) -> void:
	._input_process(delta)

func _input_physics_process(delta: float) -> void:
	._input_physics_process(delta)
	
	var player: Player = Host.Perception.get_closest_visible_object(Player)
	if player:
		var direction := int(sign(player.global_position.x - Host.global_position.x))
		var distance_x: float = abs(player.global_position.x - Host.global_position.x)
		
		stop_moving()
		if distance_x > backoff_distance:
			activate_action("move_left" if direction == -1 else "move_right")
		
		if can_jump:
			activate_action("jump")
			can_jump = false
			yield(get_tree().create_timer(jump_interval + rand_range(-jump_deviation, jump_deviation), false), "timeout")
			can_jump = true
	
	elif Host.is_on_wall() && can_change_direction:
		stop_moving()
		activate_action("move_left" if Host.look_direction == 1 else "move_right")
		
		can_change_direction = false
		yield(get_tree().create_timer(0.2, false), "timeout")
		can_change_direction = true

func stop_moving() -> void:
	deactivate_action("move_left")
	deactivate_action("move_right")
