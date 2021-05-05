extends GameState
class_name PlayState

onready var PauseMenu = $".."/UI/PauseMenu
onready var Transition := $".."/UI/Transition
onready var PlayUI := $".."/UI/PlayUI

var current_scene: Node

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:

	if !get_tree().paused:
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

func _state_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if state_machine._push_state(PauseMenu):
			return
