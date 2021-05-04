extends GameState
class_name PlayState

onready var Transition := $".."/UI/Transition
onready var PlayUI := $".."/UI/PlayUI

var current_scene: Node

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:

	assert("scene" in params && params.scene is Node)
	
	if current_scene:
		remove_child(current_scene)
		current_scene.queue_free()
	
	current_scene = params.scene
	add_child(params.scene)
	current_scene.set_ui(PlayUI)
	
	._state_enter(previous_state, params)
	
	Transition.start("fade_in")
	yield(Transition, "transition_finished")
