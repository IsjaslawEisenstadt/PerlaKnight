extends GameState
class_name RuneAbilityInterface

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	$AnimationPlayer.play("blur")
	$AnimationPlayer.advance(0)
	._state_enter(previous_state, params)

func _state_process(delta: float) -> void:
	._state_process(delta)

	if (Input.is_action_just_pressed("runes") || Input.is_action_just_pressed("ui_cancel")):
		close()

func blur_finished(_animation_name: String) -> void:
	state_machine._pop_state()

func close() -> void:
	if is_active() && !$AnimationPlayer.is_playing():
		$AnimationPlayer.connect("animation_finished", self, "blur_finished", [], CONNECT_ONESHOT)
		$AnimationPlayer.play_backwards("blur")
