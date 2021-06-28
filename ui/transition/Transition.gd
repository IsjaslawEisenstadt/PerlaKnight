extends Control
class_name Transition

signal transition_finished()

onready var TransitionEffect = $TransitionEffect
onready var AnimationPlayer = $AnimationPlayer

var last_transition_name: String

func _ready() -> void:
	TransitionEffect.visible = false

func start(transition_name: String) -> void:
	last_transition_name = transition_name
	TransitionEffect.visible = true
	AnimationPlayer.play(transition_name + "_out")

func end() -> void:
	TransitionEffect.visible = true
	AnimationPlayer.play(last_transition_name + "_in")

func is_playing() -> bool:
	return AnimationPlayer.is_playing()

func _on_AnimationPlayer_animation_finished(_animation_name: String) -> void:
	emit_signal("transition_finished")
