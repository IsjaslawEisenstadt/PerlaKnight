extends Area2D
class_name Destructible

export var destruct_animation_name: String = "destruct"

export(Array, Resource) var possible_drops := []

func _ready() -> void:
	if !is_connected("area_entered", self, "on_area_entered"):
		connect("area_entered", self, "on_area_entered")

func drop_random(drop_dir: int = 1) -> void:
	for drop in possible_drops:
		assert(drop is Drop)
		if randf() <= drop.drop_chance:
			assert(drop.loot_pickup)
			
			var new_loot = drop.loot_pickup.instance()
		
			# TODO: find a cleaner solution for this
			get_parent().get_parent().add_child(new_loot)
			
			new_loot.global_position = global_position
			new_loot._launch(drop_dir)

func on_area_entered(area) -> void:
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play(destruct_animation_name)
		if $AudioStreamPlayer2D.playing == false:
			$AudioStreamPlayer2D.play()
		
		var drop_dir := int(sign((global_position - area.global_position).x))
		# calling immediately causes physics issues
		call_deferred("drop_random", drop_dir)
		
		yield($AnimationPlayer, "animation_finished")
		if $AudioStreamPlayer2D.playing:
			yield($AudioStreamPlayer2D, "finished")
		
		destroy()

func destroy() -> void:
	get_parent().remove_child(self)
	queue_free()
