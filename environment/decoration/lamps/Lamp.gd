tool
extends Sprite

enum LampType {
	BURNING_1,
	BURNING_2,
	BURNING_3,
	BURNING_4,
	BURNING_5
}

export(LampType) var type: int = LampType.BURNING_1

func _enter_tree() -> void:
	$AnimationPlayer.play("burn")

func _process(_delta: float) -> void:
	frame = ($AnimationPlayer.current_animation_position * 10) + (type * $AnimationPlayer.current_animation_length * 10)
