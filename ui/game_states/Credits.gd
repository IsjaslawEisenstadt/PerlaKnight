extends Control
class_name Credits

signal scroll_finished()

export var regular_scroll_time: float = 0.02
export var fast_scroll_time: float = 0.003
export var scroll_end_pause: float = 2.5

var is_scrolling: bool = false

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if visible && Input.is_action_just_pressed("pause"):
		emit_signal("scroll_finished")

func start_scroll() -> void:
	$Scroll.scroll_vertical = 0.0
	$ScrollTimer.start(fast_scroll_time if Input.is_action_pressed("jump") else regular_scroll_time)

func on_scroll_timeout() -> void:
	if visible:
		var previous_scroll = $Scroll.scroll_vertical
		$Scroll.scroll_vertical += 1
		if previous_scroll != $Scroll.scroll_vertical:
			$ScrollTimer.start(fast_scroll_time if Input.is_action_pressed("jump") else regular_scroll_time)
		else:
			yield(get_tree().create_timer(scroll_end_pause), "timeout")
			emit_signal("scroll_finished")
