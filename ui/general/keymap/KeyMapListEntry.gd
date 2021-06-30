extends Container
class_name KeyMapListEntry

export var InputEntry: PackedScene

export (String) var action_name
export (Array, Texture) var input_entry_textures

func _ready() -> void:
	assert(InputEntry)
	assert(input_entry_textures)
	assert(action_name)
	
	$MarginContainer/HBoxContainer/Action.text = action_name
	
	for texture in input_entry_textures:
		var new_entry = InputEntry.instance()
		new_entry.texture = texture
		$MarginContainer/HBoxContainer/InputEntryList.add_child(new_entry)		
