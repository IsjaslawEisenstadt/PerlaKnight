tool
extends Control
class_name DialogueBox

signal line_finished()

export(String, MULTILINE) var text: String = "" setget set_text
export var scroll_time: float = 0.05
export var icon_offset: float = 6.0

export var large_pause_time: float = 0.8
export var medium_pause_time: float = 0.4
export var short_pause_time: float = 0.2

var current_character: int = 0

var force_line_finish: bool = false

func _ready() -> void:
	$Icons.visible = false

func _enter_tree() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	rect_size = Vector2.ZERO
	$Offset.rect_size = Vector2.ZERO
	$Offset/Panel.rect_size = Vector2.ZERO
	
	$Icons/IconLeftOffset.position.x = -($Offset/Panel.rect_size.x / 2) + icon_offset
	$Icons/IconRightOffset.position.x = ($Offset/Panel.rect_size.x / 2) - icon_offset
	$Icons.position.y = -($Offset/Panel.rect_size.y / 2)
	
	if !Engine.editor_hint && Input.is_action_just_pressed("talk"):
		if $ScrollTimer.is_stopped():
			emit_signal("line_finished")
		else:
			force_finish()

func set_text(new_text: String) -> void:
	text = new_text
	start_scroll()

func start_scroll() -> void:
	if has_node("Offset"):
		$Icons.visible = false
		current_character = 0
		$Offset/Panel/Margin/Label.text = ""
		$Offset/Panel.rect_position = Vector2.ZERO
		on_scroll_timeout()

func show_icons() -> void:
	$Icons.visible = true
	$IconAnimator.play("bounce")

func is_char_in_bounds(index: int) -> bool:
	return index < text.length()

func force_finish() -> void:
	force_line_finish = true
	$ScrollTimer.stop()
	
	var skip: bool = false
	while is_char_in_bounds(current_character):
		var c = text[current_character]
		if skip:
			if c == ']':
				skip = false
		else:
			if c == '[':
				skip = true
			else:
				$Offset/Panel/Margin/Label.text += c
		current_character += 1
	show_icons()

func on_scroll_timeout() -> void:
	
	if force_line_finish:
		return
	
	if !is_char_in_bounds(current_character):
		show_icons()
		return
	
	var pause_time: float = scroll_time
	if text[current_character] == '[':
		
		if !is_char_in_bounds(current_character + 2):
			show_icons()
			return
		
		match text[current_character + 1] + text[current_character + 2]:
			"L]":
				pause_time = large_pause_time
			"M]":
				pause_time = medium_pause_time
			"S]":
				pause_time = short_pause_time
			_:
				$Offset/Panel/Margin/Label.text += text[current_character]
				current_character -= 2
		current_character += 3
	else:
		$Offset/Panel/Margin/Label.text += text[current_character]
		current_character += 1
	
	$ScrollTimer.start(pause_time)
