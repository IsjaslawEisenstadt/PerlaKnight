tool
extends Control
class_name DialogueBox

export(String, MULTILINE) var text: String = "" setget set_text
export var scroll_time: float = 0.05

var current_character: int = 0

func start_scroll() -> void:
	if has_node("Offset"):
		current_character = 0
		$Offset/Panel/Margin/Label.text = ""
		$Offset/Panel.rect_position = Vector2.ZERO
		on_scroll_timeout()

func _enter_tree() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	rect_size = Vector2.ZERO
	$Offset.rect_size = Vector2.ZERO
	$Offset/Panel.rect_size = Vector2.ZERO

func set_text(new_text: String) -> void:
	text = new_text
	start_scroll()

func is_char_in_bounds(index: int) -> bool:
	return index < text.length()

func on_scroll_timeout() -> void:
	
	if !is_char_in_bounds(current_character):
		return
	
	var pause_time: float = scroll_time
	if text[current_character] == '[':
		var pause_str: String = ""
		var i: int = current_character + 1
		
		while is_char_in_bounds(i) && text[i] != ']':
			pause_str += text[i]
			i += 1
		
		if !is_char_in_bounds(i):
			return
		
		current_character = i + 1
		pause_time = float(pause_str)
	else:
		$Offset/Panel/Margin/Label.text += text[current_character]
		current_character += 1
	
	$ScrollTimer.start(pause_time)
