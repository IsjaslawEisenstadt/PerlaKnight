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

func _can_interact(_character) -> bool:
	return visible

func _interact(character) -> void:
	visible = false
	character.add_rune(rune.resource_name)

func save_game(save_data: Dictionary, level) -> void:
	if !visible:
		var rune_data: String = rune.resource_name
		if rune_data == "HealthRune":
			rune_data += "_%s_%s" % [level.name, name]
		if !"runes" in save_data:
			save_data.runes = []
		if !rune_data in save_data.runes:
			save_data["runes"].append(rune_data)

func load_game(save_data: Dictionary, level) -> void:
	if ("runes" in save_data 
		&& (rune.resource_name in save_data.runes 
		|| "HealthRune_%s_%s" % [level.name, name] in save_data.runes)):
		visible = false
