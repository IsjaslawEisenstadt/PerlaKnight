extends Destructible
class_name LootDestructible

export (Array, Resource) var possible_drops = []

func _on_destroyed() -> void:
	drop_random()
	
func drop_random() -> void:
	for drop in possible_drops:
		if drop is Drop && (randf() <= drop.drop_chance):
			drop(drop.loot_pickup)
	
func drop(lootScene: PackedScene) -> void:
	var new_loot = lootScene.instance()
	new_loot.position = position
	
	get_parent().get_parent().add_child(new_loot)
	
