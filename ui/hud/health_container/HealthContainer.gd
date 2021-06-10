extends Control

onready var root: Control = $HBoxContainer

export var HeartScene: PackedScene

# the hearts shouldn't be animated when the game is first loaded
# this flag is a workaround that is passed to the hearts to tell them
# to immediately activate without an animation
var activate_immediately: bool

func _ready() -> void:
	visible = false

func on_player_connected(player: Player) -> void:
	activate_immediately = true
	
	set_max_health(player.max_health)
	set_health(player.current_health)
	
	visible = true
	
	player.connect("health_changed", self, "set_health")
	player.connect("max_health_changed", self, "set_max_health")
	
	# delay one frame before allowing heart animations
	yield(get_tree(), "idle_frame")
	activate_immediately = false

func on_player_disconnected(player: Player) -> void:
	visible = false
	player.disconnect("health_changed", self, "set_health")
	player.disconnect("max_health_changed", self, "set_max_health")
	for heart in root.get_children():
		root.remove_child(heart)
		heart.queue_free()

func set_max_health(max_health: int) -> void:
	var health_difference: int = max_health - root.get_child_count()
	if health_difference > 0:
		for _i in range(health_difference):
			var new_heart = HeartScene.instance()
			root.add_child(new_heart)
		for heart in root.get_children():
			if !heart.is_filled():
				heart.set_filled(true, activate_immediately)
	else:
		for i in range(abs(health_difference) + 1, 1):
			var children = root.get_children()
			root.remove_child(children[-i])

func set_health(health: int) -> void:
	var i: int = 0
	for heart in root.get_children():
		var should_fill: bool = i < health
		if heart.is_filled() != should_fill:
			heart.set_filled(i < health, activate_immediately)
		i += 1

func get_health() -> int:
	var health: int = 0
	for heart in root.get_children():
		if heart.is_filled():
			health += 1
	return health
