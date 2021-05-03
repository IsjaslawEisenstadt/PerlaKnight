extends Control
class_name WorldSpaceUI

onready var InteractionIcon := $InteractionIcon

var player: Player

func _ready() -> void:
	InteractionIcon.visible = false

func _process(_delta: float) -> void:
	if player && player.closest_interaction:
		InteractionIcon.global_position = get_screen_space_position(player.closest_interaction.IconPosition)
		InteractionIcon.visible = true
	else:
		InteractionIcon.visible = false

func connect_player(player_: Player) -> void:
	self.player = player_

func disconnect_player(_player: Player) -> void:
	self.player = null

func get_screen_space_position(node: CanvasItem) -> Vector2:
	return node.get_global_transform_with_canvas().get_origin()
