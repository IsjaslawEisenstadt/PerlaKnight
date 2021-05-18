tool
extends Interaction
class_name RuneContainer

export var rune: Resource

func _ready() -> void:
	if rune:
		assert(rune is Rune)
		$Sprite.texture = rune.texture 
		$AnimationPlayer.play("hover")
		$AnimationPlayer.advance(randf() * $AnimationPlayer.current_animation_length)

func _interact(character) -> void:
	character.add_rune(rune)
	queue_free()
