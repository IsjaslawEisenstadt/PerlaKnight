extends Button

func _ready() -> void:
	connect("mouse_entered", self, "grab_focus")
