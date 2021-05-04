extends GameState
class_name LoadingScreen

signal load_finished(resource)

onready var PlayState := $"../.."/PlayState

export var max_load_ms_per_frame: float = 100

var loader: ResourceInteractiveLoader

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)

	assert("scene" in params)
	
	loader = ResourceLoader.load_interactive(params.scene)
	assert(loader)
	var scene: Node = yield(self, "load_finished").instance()
	
	loader = null
	state_machine._pop_push(PlayState, {"scene": scene})

func _state_process(delta: float) -> void:
	._state_process(delta)
	
	var time = OS.get_ticks_msec()
	while OS.get_ticks_msec() < time + max_load_ms_per_frame:
		var err = loader.poll()
		assert(err == OK || err == ERR_FILE_EOF)
		if err == OK:
			$Label.text = str((float(loader.get_stage()) / float(loader.get_stage_count())) * 100.0) + "%"
		elif err == ERR_FILE_EOF:
			emit_signal("load_finished", loader.get_resource())
			return
