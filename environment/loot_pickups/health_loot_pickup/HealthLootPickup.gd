extends LootPickup
class_name HealthLootPickup

export var heal_amount := 1

func _on_pickup(player: Player) -> void:
	._on_pickup(player)
	
	if player.current_health < player.max_health:
		player.heal(heal_amount)
		queue_free()
