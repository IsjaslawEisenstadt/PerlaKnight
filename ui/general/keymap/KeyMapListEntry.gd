extends Container
class_name KeyMapListEntry

export var InputEntry : PackedScene

func _ready() -> void:
	assert(InputEntry)

func add_action(action) -> void:
	$MarginContainer/HBoxContainer/Action.text = action
	
	for input in InputMap.get_action_list(action):
		var new_entry : RichTextLabel = InputEntry.instance() as RichTextLabel
		new_entry.text = input.as_text()
		
		$MarginContainer/HBoxContainer/InputEntryList.add_child(new_entry)
