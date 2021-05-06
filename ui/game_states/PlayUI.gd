extends Control
class_name PlayUI

signal player_connected(player)
signal player_disconnected(player)

onready var Transition := $".."/Transition

func _ready() -> void:
	visible = true

func transition_to_checkpoint(player: Player):
	Transition.start("fade_out")
	yield(Transition, "transition_finished")
	player.reset()
	Transition.start("fade_in")

func connect_player(player: Player) -> void:
	emit_signal("player_connected", player)
	player.connect("transition_to_checkpoint", self, "transition_to_checkpoint", [player])

func disconnect_player(player: Player) -> void:
	emit_signal("player_disconnected", player)
	player.disconnect("transition_to_checkpoint", self, "transition_to_checkpoint")
