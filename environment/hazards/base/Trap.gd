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
	

func _on_Spike_Sprite_frame_changed():
	if $Sprite.frame == 16:
		$SpikeSound._play()


func _on_Pillar_Sprite_frame_changed():
	if $Sprite.frame == 4:
		$ImpactSound._play()

