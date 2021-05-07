extends GameState
class_name PlayState

onready var PauseMenu = $".."/UI/PauseMenu
onready var Transition := $".."/UI/Transition
onready var PlayUI := $".."/UI/PlayUI

var current_scene: Node

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	if "scene" in params:
		assert(params.scene is Node)
		if current_scene:
			remove_child(current_scene)
			current_scene.queue_free()
		
		current_scene = params.scene
		add_child(params.scene)
		if current_scene is Level:
			current_scene.set_ui(PlayUI)
			
		Transition.start("fade_in")
	else:
		assert(current_scene, "entered PlayState without scene param or previously active scene")

func _state_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		state_machine._push_state(PauseMenu)
