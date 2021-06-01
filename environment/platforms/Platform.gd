extends StaticBody2D
class_name Platform

func disable() -> void:
	set_collision_layer_bit(0, false)
	
func enable() -> void:
	set_collision_layer_bit(0, true)
