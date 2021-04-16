tool
extends EditorPlugin

var import_plugin = null

func get_plugin_name():
	return "LDtk Importer"

func _enter_tree():
	import_plugin = preload("LDtkImporter.gd").new()
	import_plugin.connect("import_finished", self, "on_import_finished", [], CONNECT_DEFERRED)
	add_import_plugin(import_plugin)

func _exit_tree():
	remove_import_plugin(import_plugin)
	import_plugin.disconnect("import_finished", self, "on_import_finished")
	import_plugin = null

func on_import_finished(path) -> void:
	var scene_path = path.get_basename() + ".tscn"
	var eif := get_editor_interface()
	for scene in eif.get_open_scenes():
		if scene == scene_path:
			eif.reload_scene_from_path(scene)
