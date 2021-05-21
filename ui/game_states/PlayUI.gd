extends Control
class_name PlayUI

signal player_connected(player)
signal player_disconnected(player)

func _ready() -> void:
	visible = true

func connect_player(player: Player) -> void:
	emit_signal("player_connected", player)

func disconnect_player(player: Player) -> void:
	emit_signal("player_disconnected", player)
