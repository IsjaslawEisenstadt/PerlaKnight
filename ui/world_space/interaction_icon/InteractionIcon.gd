extends Sprite

var player: Player

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if player && player.closest_interaction:
		global_position = get_screen_space_position(player.closest_interaction.IconPosition)
		visible = true
	else:
		visible = false

func on_player_connected(player_: Player) -> void:
	player = player_

func on_player_disconnected(_player: Player) -> void:
	player = null

func get_screen_space_position(node: CanvasItem) -> Vector2:
	return node.get_global_transform_with_canvas().get_origin()
