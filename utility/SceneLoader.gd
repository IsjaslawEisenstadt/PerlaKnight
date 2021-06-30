extends Node

signal load_finished(resource)

export var max_load_ms_per_frame: float = 100

var loader: ResourceInteractiveLoader

func _ready() -> void:
	set_process(false)
	pause_mode = PAUSE_MODE_PROCESS

func load_scene(load_path: String) -> void:
	if loader:
		yield(self, "load_finished")
	#get_tree().paused = true
	loader = ResourceLoader.load_interactive(load_path)
	assert(loader)
	set_process(true)

func _process(_delta: float) -> void:
	var time = OS.get_ticks_msec()
	while OS.get_ticks_msec() < time + max_load_ms_per_frame:
		var err = loader.poll()
		assert(err == OK || err == ERR_FILE_EOF)
		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			loader = null
			#get_tree().paused = false
			set_process(false)
			emit_signal("load_finished", resource)
			return
