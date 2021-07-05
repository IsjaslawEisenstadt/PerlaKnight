extends Hazard
class_name Trap

export var interval: float = 0.0

var interval_timer := Timer.new()

func _ready() -> void:
	interval_timer.connect("timeout", self, "interval_timout")
	add_child(interval_timer)
	interval_timer.start(interval)

func interval_timout() -> void:
	$AnimationPlayer.play("trigger")
