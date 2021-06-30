extends GameState
class_name KeyMap

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	pause_game = true
	._state_enter(previous_state, params)

func _state_exit(_next_state: State, _params: Dictionary = {}) -> void:
	._state_exit(_next_state, _params)

func on_BackButton_pressed() -> void:
	state_machine._pop_state()
