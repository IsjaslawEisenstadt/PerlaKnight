extends MarginContainer
class_name HelpHUD

func on_player_connected(player: Player) -> void:
	visible = true

func on_player_disconnected(player: Player) -> void:
	visible = false
