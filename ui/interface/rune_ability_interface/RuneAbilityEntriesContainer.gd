extends BoxContainer

export var RuneAbilityEntry : PackedScene

func on_player_connected(player: Player) -> void:
	player.connect("rune_added", self, "add_rune")

func on_player_disconnected(player):
	player.disconnect("rune_added", self, "add_rune")

func add_rune(rune):
	var new_entry = RuneAbilityEntry.instance()
	add_child(new_entry)
	new_entry.init(rune)
