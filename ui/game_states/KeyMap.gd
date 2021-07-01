extends GameState
class_name KeyMap

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	$AnimationPlayer.play("blur")
	$AnimationPlayer.advance(0)
	._state_enter(previous_state, params)

func blur_finished(_animation_name: String) -> void:
	state_machine._pop_state()

func can_press() -> bool:
	return is_active() && !$AnimationPlayer.is_playing()	

func close() -> void:
	$AnimationPlayer.connect("animation_finished", self, "blur_finished", [], CONNECT_ONESHOT)
	$AnimationPlayer.play_backwards("blur")
	
func _state_process(_delta: float) -> void:
	._state_process(_delta)
	
	if can_press() && (Input.is_action_just_pressed("help") || Input.is_action_just_pressed("ui_cancel")):
		close()
