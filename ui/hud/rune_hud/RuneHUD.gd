extends MarginContainer
class_name RuneHUD

onready var Root := $HBox

func on_rune_added(rune: Rune) -> void:
	# We don't want to display health runes 
	# because the HealthContainer already shows their effect
	if rune.name != "Health Rune":
		var new_entry := RuneEntry.new()
		new_entry.rune = rune
		Root.add_child(new_entry)

func on_player_connected(player: Player) -> void:
	player.connect("rune_added", self, "on_rune_added")
	visible = true
	for child in Root.get_children():
		Root.remove_child(child)
		child.queue_free()

func on_player_disconnected(player: Player) -> void:
	player.disconnect("rune_added", self, "on_rune_added")
	visible = false
