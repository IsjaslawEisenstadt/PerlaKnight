extends State
class_name GameState

# some states want to stay visible while not active
export var inactive_visibility = false
export var pause_game: bool = false

func _ready() -> void:
	self.visible = inactive_visibility

func _state_enter(_previous_state: State, _params: Dictionary = {}) -> void:
	self.visible = true
	get_tree().paused = pause_game

func _state_exit(_next_state: State) -> void:
	self.visible = inactive_visibility
	# not strictly neccessary but good hygiene anyways
	get_tree().paused = !pause_game
