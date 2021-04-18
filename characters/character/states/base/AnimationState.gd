extends CharacterState
class_name AnimationState

"""
State that plays an animation while active.
"""

export var animation_name: String = ""
export var animation_speed: float = 1.0

var current_animation_name: String = "" setget set_current_animation_name
var current_animation_speed: float = 1.0

func _state_enter(previous_state: State, _params = null) -> void:
	._state_enter(previous_state)

	current_animation_speed = animation_speed
	self.current_animation_name = animation_name

	# Make sure the current animation sprite is displayed
	host.AnimationPlayer.advance(0)

func set_current_animation_name(anim_name: String) -> void:
	current_animation_name = anim_name
	host.play_animation(current_animation_name, current_animation_speed)

func _on_animation_finished(_finished_animation_name: String) -> void:
	pass
