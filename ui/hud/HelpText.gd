extends Control

func _ready() -> void:
	visible = false

func on_player_connected(_player: Player) -> void:
	visible = true

func on_player_disconnected(_player: Player) -> void:
	visible = false
