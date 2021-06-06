extends Area2D
class_name Destructible

export var destruct_animation_name: String = "destruct"

export(Array, Resource) var possible_drops := []

func _ready() -> void:
	if !is_connected("area_entered", self, "on_area_entered"):
		connect("area_entered", self, "on_area_entered")

func drop_random() -> void:
	for drop in possible_drops:
		assert(drop is Drop)
		if randf() <= drop.drop_chance:
			assert(drop.loot_pickup)
			
			var new_loot = drop.loot_pickup.instance()
			new_loot.position = position
		
			# TODO: find a cleaner solution for this
			get_parent().get_parent().add_child(new_loot)

func on_area_entered(_area) -> void:
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play(destruct_animation_name)

func on_animation_finished(anim_name):
	if anim_name == destruct_animation_name:
		drop_random()
		get_parent().remove_child(self)
		queue_free()
