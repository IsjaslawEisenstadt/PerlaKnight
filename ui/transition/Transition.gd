extends Control
class_name Transition

signal transition_finished()

onready var TransitionEffect = $TransitionEffect
onready var AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	TransitionEffect.visible = false

func start(transition_name: String) -> void:
	TransitionEffect.visible = true
	AnimationPlayer.play(transition_name)

func is_playing() -> bool:
	return AnimationPlayer.is_playing()

func _on_AnimationPlayer_animation_finished(_animation_name: String) -> void:
	emit_signal("transition_finished")
	TransitionEffect.visible = false
