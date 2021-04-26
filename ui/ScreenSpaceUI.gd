extends Control
class_name ScreenSpaceUI

onready var HeartContainer := $HUD/HealthContainer

func connect_player(player: Player) -> void:
	HeartContainer.set_max_health(player.max_health)
	player.connect("health_changed", HeartContainer, "set_health")

func disconnect_player(player: Player) -> void:
	player.disconnect("health_changed", HeartContainer, "set_health")
