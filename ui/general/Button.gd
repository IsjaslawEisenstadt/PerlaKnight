extends Button

func _ready() -> void:
	connect("mouse_entered", self, "try_grab_focus")

func try_grab_focus() -> void:
	if focus_mode == Control.FOCUS_ALL:
		grab_focus()
