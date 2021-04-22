extends GameState
class_name LevelState

func _state_exit(_next_state: State) -> void:
	get_parent().remove_child(self)
	queue_free()
