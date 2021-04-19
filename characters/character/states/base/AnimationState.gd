extends CharacterState
class_name AnimationState

"""
State that plays an animation while active.
"""

export var animation_name: String = ""
export var animation_speed: float = 1.0


func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	host.play_animation(animation_name, animation_speed)

func _on_animation_finished(_finished_animation_name: String) -> void:
	pass
