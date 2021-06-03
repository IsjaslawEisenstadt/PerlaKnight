extends LootPickup
class_name HealthLootPickup

export var heal_amount := 1

func _is_collectible() -> bool:
	return player.current_health < player.max_health
		
func _on_pickup(player) -> void:
	player.heal(heal_amount)
	queue_free()
