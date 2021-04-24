extends GameState
class_name PlayState

onready var LoadingScreen := get_node(loading_screen_path) as GameState
onready var Transition := get_node(transition_path) as Transition

export var loading_screen_path: NodePath = "../ScreenSpaceUI/LoadingScreen"
export var transition_path: NodePath = "../ScreenSpaceUI/Transition"

export(String, FILE, "*.tscn,*.scn,*.ldtk") var new_game_scene_path: String

var current_scene: Node

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	if "scene" in params:
		if current_scene:
			remove_child(current_scene)
			current_scene.queue_free()
		current_scene = params.scene
		add_child(current_scene)
		
		._state_enter(previous_state, params)
		
		Transition.start("fade_in")
		yield(Transition, "transition_finished")
		Transition.visible = false
	else:
		state_machine._push_state(LoadingScreen, { "scene_path": new_game_scene_path })
