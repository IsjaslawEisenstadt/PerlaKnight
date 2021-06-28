extends GameState
class_name KeyMap

export var KeyMapListEntry: PackedScene

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	assert(KeyMapListEntry)
	
	pause_game = true
	._state_enter(previous_state, params)
	
	for action in InputMap.get_actions():
		if InputMap.get_action_list(action).size() > 0:
			var new_entry = KeyMapListEntry.instance()
			$Content/VBoxContainer/ScrollContainer/VBoxContainer.add_child(new_entry)
			
			new_entry.add_action(action)

func _state_exit(_next_state: State, _params: Dictionary = {}) -> void:
	._state_exit(_next_state, _params)

func on_BackButton_pressed() -> void:
	state_machine._pop_state()
