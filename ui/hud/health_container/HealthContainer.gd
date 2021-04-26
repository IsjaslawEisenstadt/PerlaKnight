extends Control

onready var root: Control = $HBoxContainer

export var HeartScene: PackedScene

func set_max_health(max_health: int) -> void:
	var health_difference: int = max_health - root.get_child_count()
	if health_difference > 0:
		for heart in root.get_children():
			heart.set_filled = true
		for _i in range(health_difference):
			var new_heart = HeartScene.instance()
			new_heart.is_filled = true
			root.add_child(new_heart)
	else:
		for i in range(abs(health_difference) + 1, 1):
			var children = root.get_children()
			root.remove_child(children[-i])

func set_health(health: int) -> void:
	var i: int = 0
	for heart in root.get_children():
		heart.is_filled = i < health
		i += 1

func get_health() -> int:
	var health: int = 0
	for heart in root.get_children():
		if heart.is_filled:
			health += 1
	return health
