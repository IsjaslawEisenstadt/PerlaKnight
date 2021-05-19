extends Control
class_name LoadingScreen

signal load_finished(resource)

export var max_load_ms_per_frame: float = 100

var loader: ResourceInteractiveLoader

func _ready() -> void:
	visible = false
	set_process(false)

func load_scene(load_path: String) -> void:
	visible = true
	get_tree().paused = true
	loader = ResourceLoader.load_interactive(load_path)
	assert(loader)
	set_process(true)

func _process(_delta: float) -> void:
	var time = OS.get_ticks_msec()
	while OS.get_ticks_msec() < time + max_load_ms_per_frame:
		var err = loader.poll()
		assert(err == OK || err == ERR_FILE_EOF)
		if err == OK:
			$Label.text = str((float(loader.get_stage()) / float(loader.get_stage_count())) * 100.0) + "%"
		elif err == ERR_FILE_EOF:
			emit_signal("load_finished", loader.get_resource())
			loader = null
			visible = false
			get_tree().paused = false
			set_process(false)
			return
