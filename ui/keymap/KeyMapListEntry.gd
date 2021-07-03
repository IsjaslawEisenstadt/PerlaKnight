tool
extends Container
class_name KeyMapListEntry

export var InputEntry: PackedScene

export (String) var action_name setget set_action_name
export (Array, Texture) var input_entry_textures setget set_input_entry_textures

func _ready() -> void:
	assert(InputEntry)
	assert(input_entry_textures)
	assert(action_name)

func set_action_name(new_action_name):
	action_name = new_action_name
	$MarginContainer/HBoxContainer/CenterContainer/Action.text = action_name
	
func set_input_entry_textures(new_input_entry_textures):
	input_entry_textures = new_input_entry_textures
	
	for child in $MarginContainer/HBoxContainer/MarginContainer/InputEntryList.get_children():
		$MarginContainer/HBoxContainer/MarginContainer/InputEntryList.remove_child(child)
		
	for texture in input_entry_textures:
		var new_entry = InputEntry.instance()
		new_entry.get_node("Texture").texture = texture
		$MarginContainer/HBoxContainer/MarginContainer/InputEntryList.add_child(new_entry)		
	
