extends Control
class_name ScreenSpaceUI

onready var HeartContainer := $HUD/HealthContainer
onready var Transition := get_node(transition_path) as Transition

export var transition_path: NodePath = "../../Transition"

func transition_to_checkpoint(player: Player):
	Transition.start("fade_out")
	yield(Transition, "transition_finished")
	player.reset()
	Transition.start("fade_in")
	
func connect_player(player: Player) -> void:
	HeartContainer.set_max_health(player.max_health)
	player.connect("health_changed", HeartContainer, "set_health")
	player.connect("transition_to_checkpoint", self, "transition_to_checkpoint", [player])

func disconnect_player(player: Player) -> void:
	player.disconnect("health_changed", HeartContainer, "set_health")
	player.disconnect("transition_to_checkpoint", self, "transition_to_checkpoint")
