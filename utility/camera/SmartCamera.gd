extends KinematicBody2D
class_name SmartCamera

var player: Player setget set_player

func _ready() -> void:
	if player:
		set_process(true)
		global_position = player.global_position
	else:
		set_process(false)

func _process(_delta: float) -> void:
	if position != player.position:
		var move: Vector2 = player.position - position
		move_and_collide(Vector2(move.x, 0.0))
		move_and_collide(Vector2(0.0, move.y))

func set_player(player_: Player) -> void:
	player = player_
