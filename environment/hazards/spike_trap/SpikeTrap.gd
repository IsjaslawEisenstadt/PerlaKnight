extends Hazard
class_name SpikeTrap

export var interval := 0.0

var interval_timer := Timer.new()

func _ready():
	interval_timer.connect("timeout", self, "interval_timout")
	add_child(interval_timer)
	interval_timer.start(interval)
	
func interval_timout():
	$AnimationPlayer.play("Trigger")
