extends CharacterState
class_name AnimationState

"""
State that plays an animation while active.
"""

export var animation_name: String = ""
export var animation_speed: float = 1.0

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	if "animation_override" in params:
		if "animation_name" in params.animation_override:
			play_animation(params.animation_override.animation_name, animation_speed, params.animation_override.frame)
	else:
		play_animation()

func play_animation(anim_name := animation_name, anim_speed := animation_speed, advance_delta := 0.0) -> void:
	host.play_animation(anim_name, anim_speed)
	host.AnimationPlayer.advance(advance_delta)

func is_playing(anim_name: String) -> bool:
	return host.AnimationPlayer.is_playing() && host.AnimationPlayer.current_animation == anim_name

func _on_animation_finished(_finished_animation_name: String) -> void:
	pass
