tool
extends EditorImportPlugin

signal import_finished(path)

enum Presets { PRESET_DEFAULT, PRESET_COLLISIONS }
var LDtk = preload("LDtk.gd").new()

func get_importer_name():
	return "LDtk.import"

func get_visible_name():
	return "LDtk Scene"

func get_priority():
	return 1

func get_import_order():
	return 100

func get_resource_type():
	return "PackedScene"

func get_recognized_extensions():
	return ["ldtk"]

func get_save_extension():
	return "tscn"

func get_preset_count():
	return Presets.size()

func get_preset_name(preset):
	match preset:
		Presets.PRESET_DEFAULT:
			return "Default"
		Presets.PRESET_COLLISIONS:
			return "Import Collisions"

func get_import_options(preset):
	return [
		{
			"name": "Import_Collisions",
			"default_value": preset == Presets.PRESET_COLLISIONS
		},
		{
			"name": "Import_Custom_Entities",
			"default_value": true,
			"hint_string": "If true, will only use this project's scenes. If false, will import objects as simple scenes."
		},
		{
			"name": "Import_Metadata",
			"default_value": true,
			"hint_string": "If true, will import entity fields as metadata."
		},
		{
			"name": "Reload_Inheriting_Scene",
			"default_value": true,
			"hint_string": "Will try to find a .tscn scene File with the same name as the imported .ldtk file and reload it. (unsaved changes might be lost)"
		}
	]

func get_option_visibility(option, options):
	return true

func import(source_file, save_path, options, platform_v, r_gen_files):
	#load LDtk map
	LDtk.map_data = source_file

	var map = Node2D.new()
	map.name = source_file.get_file().get_basename()
	
	var world_env_scene = load("res://maps/world_environment/WorldEnvironment.tscn")
	
	#add levels as Node2D
	for level in LDtk.map_data.levels:
		var new_level = Level.new()
		new_level.name = level.identifier
		
		if level.identifier.begins_with("Tutorial"):
			new_level.level_type = new_level.LevelTypes.FOREST
		
		var world_env = world_env_scene.instance()
		new_level.add_child(world_env, true)
		world_env.set_owner(new_level)

		#add layers
		
		var added_entities := []
		var layerInstances = get_level_layerInstances(level, options, added_entities)
		for layerInstance in layerInstances:
			new_level.add_child(layerInstance)
			layerInstance.set_owner(new_level)

			for child in layerInstance.get_children():
				child.set_owner(new_level)
				
				if not options.Import_Custom_Entities:
					for grandchild in child.get_children():
						grandchild.set_owner(new_level)
		
		new_level.new_entities(added_entities)
		var packed_scene = PackedScene.new()
		packed_scene.pack(new_level)
		
		var dir = Directory.new()
		if !dir.dir_exists(source_file.get_base_dir() + "/levels/"):
			dir.make_dir(source_file.get_base_dir() + "/levels/")
		
		var path = source_file.get_base_dir() + "/levels/" + new_level.name + ".tscn"
		var ret = ResourceSaver.save(path, packed_scene)
		
		var child = load(path).instance()
		map.add_child(child)
		child.set_owner(map)

	var packed_scene = PackedScene.new()
	packed_scene.pack(map)
	
	var ret = ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], packed_scene)
	if options.Reload_Inheriting_Scene:
		emit_signal("import_finished", source_file)
	return ret

#create layers in level
func get_level_layerInstances(level, options, added_entities := []):
	var layers = []
	var i = level.layerInstances.size()
	for layerInstance in level.layerInstances:
		match layerInstance.__type:
			'Entities':
				var new_node = Node2D.new()
				new_node.z_index = i
				new_node.name = layerInstance.__identifier
				var entities = LDtk.get_layer_entities(layerInstance, level, options)
				for entity in entities:
					new_node.add_child(entity)
				added_entities.append_array(entities)
				layers.push_front(new_node)
			'Tiles', 'IntGrid', 'AutoLayer':
				var new_layer = LDtk.new_tilemap(layerInstance, level)
				if new_layer:
					new_layer.z_index = i
					if options.Import_Collisions:
						new_layer.name = new_layer.name.trim_prefix("Collision_")
					layers.push_front(new_layer)

		if layerInstance.__type == 'IntGrid':
			if options.Import_Collisions:
				var collision_layer
				if layerInstance.__identifier.begins_with("Collision_"):
					if layerInstance.__identifier == "Collision_Camera":
						# 1 << 19 is the last collision_mask
						collision_layer = LDtk.import_collisions(layerInstance, level, layerInstance.__identifier, 1 << 19)
					else:
						collision_layer = LDtk.import_collisions(layerInstance, level, layerInstance.__identifier, 1 << 0)

				if collision_layer:
					collision_layer.z_index = i
					layers.push_front(collision_layer)

		i -= 1

	return layers
