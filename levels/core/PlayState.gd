extends GameState
class_name PlayState

onready var LoadingScreen := get_node(loading_screen_path) as GameState
onready var Transition := get_node(transition_path) as Transition

onready var RuntimeScreenSpaceUIParent := get_node(runtime_screen_space_ui_parent)
onready var RuntimeWorldSpaceUIParent := get_node(runtime_world_space_ui_parent)

export var loading_screen_path: NodePath = "../ScreenSpaceUI/LoadingScreen"
export var transition_path: NodePath = "../ScreenSpaceUI/Transition"

export(String, FILE, "*.tscn,*.scn,*.ldtk") var new_game_scene_path: String

export(String, FILE, "*.tscn,*.scn") var runtime_screen_space_ui_path: String
export(String, FILE, "*.tscn,*.scn") var runtime_world_space_ui_path: String

export var runtime_screen_space_ui_parent: NodePath = "../ScreenSpaceUI/RuntimeUI"
export var runtime_world_space_ui_parent: NodePath = "../RuntimeUI"

var runtime_screen_space_ui: ScreenSpaceUI
var runtime_world_space_ui: WorldSpaceUI

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	if "scenes" in params:
		for scene in get_children():
			remove_child(scene)
			scene.queue_free()
		
		assert(params.scenes is Dictionary)
		
		if !runtime_screen_space_ui || !runtime_world_space_ui:
			runtime_screen_space_ui = params.scenes[runtime_screen_space_ui_path]
			runtime_world_space_ui = params.scenes[runtime_world_space_ui_path]
			RuntimeScreenSpaceUIParent.add_child(runtime_screen_space_ui)
			RuntimeWorldSpaceUIParent.add_child(runtime_world_space_ui)
			params.scenes.erase(runtime_screen_space_ui_path)
			params.scenes.erase(runtime_world_space_ui_path)
		
		for scene_path in params.scenes:
			var scene: Node = params.scenes[scene_path]
			add_child(params.scenes[scene_path])
			if scene is Level:
				scene.set_ui(runtime_screen_space_ui, runtime_world_space_ui)
		
		# params are consumed at this point, we don't pass it along anymore
		._state_enter(previous_state, {})
		
		Transition.start("fade_in")
		yield(Transition, "transition_finished")
	
	else:
		var scenes := {}
		if !runtime_screen_space_ui || !runtime_world_space_ui:
			scenes[runtime_screen_space_ui_path] = null
			scenes[runtime_world_space_ui_path] = null
		scenes[new_game_scene_path] = null
		state_machine._push_state(LoadingScreen, { "scenes": scenes })
