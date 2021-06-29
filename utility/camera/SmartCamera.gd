extends KinematicBody2D
class_name SmartCamera

export var speed: float = 3.0
export var interp_epsilon: float = 0.03

var player: Player setget set_player

var use_custom_target: bool = false
var custom_target: Vector2

func _ready() -> void:
	if player:
		set_process(true)
		global_position = player.global_position
	else:
		set_process(false)

func _physics_process(delta: float) -> void:
	var target = custom_target if use_custom_target else player.global_position
	
	var move: Vector2
	if use_custom_target:
		move = global_position.linear_interpolate(target, speed * delta) - global_position
		
		move.x = int(move.x * 100.0) / 100.0
		move.y = int(move.y * 100.0) / 100.0
		
		if abs(move.x) < interp_epsilon:
			move = target - global_position
	else:
		move = target - global_position
	
	move_and_collide(Vector2(move.x, 0.0))
	move_and_collide(Vector2(0.0, move.y))

func set_player(player_: Player) -> void:
	player = player_
	player.camera = self
