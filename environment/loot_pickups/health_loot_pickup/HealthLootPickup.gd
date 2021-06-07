extends LootPickup
class_name HealthLootPickup

export var heal_amount: int = 1

func _can_pickup(character) -> bool:
	return ._can_pickup(character) && character.current_health < character.max_health

func _pickup(character) -> void:
	._pickup(character)
	character.current_health += heal_amount
