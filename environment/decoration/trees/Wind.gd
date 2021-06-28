extends Sprite

func _ready() -> void:
	material.set_shader_param("offset", randf())
