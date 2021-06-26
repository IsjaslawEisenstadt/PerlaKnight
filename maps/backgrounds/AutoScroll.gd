extends ParallaxLayer

export var speed: float = 3

func _process(delta: float) -> void:
	motion_offset.x += speed * delta
