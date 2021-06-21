extends State
class_name GameState

# some states want to stay visible while not active
export var inactive_visibility = false
export var pause_game: bool = false
export var default_focus_path: NodePath

func _ready() -> void:
	self.visible = inactive_visibility

func _state_enter(_previous_state: State, _params: Dictionary = {}) -> void:
	var default_focus = get_node_or_null(default_focus_path) as Control
	if default_focus:
		default_focus.grab_focus()
	self.visible = true
	get_tree().paused = pause_game

func _state_exit(_next_state: State, _params: Dictionary = {}) -> void:
	self.visible = inactive_visibility
	# not strictly neccessary but good hygiene anyways
	get_tree().paused = !pause_game
