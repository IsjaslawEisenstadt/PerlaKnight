extends MarginContainer
class_name RuneHUD

func _ready() -> void:
	visible = true
	for child in $HBox.get_children():
		$HBox.remove_child(child)
		child.queue_free()

func on_rune_added(rune: Rune) -> void:
	# We don't want to display health runes 
	# because the HealthContainer already shows their effect
	if rune.name != "Health Rune":
		var new_entry := RuneEntry.new()
		new_entry.rune = rune
		$HBox.add_child(new_entry)

func on_player_connected(player: Player) -> void:
	player.connect("rune_added", self, "on_rune_added")

func on_player_disconnected(player: Player) -> void:
	player.disconnect("rune_added", self, "on_rune_added")
