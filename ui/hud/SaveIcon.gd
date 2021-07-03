extends Sprite

func _ready() -> void:
	visible = false

func on_save() -> void:
	$AnimationPlayer.play("show")
