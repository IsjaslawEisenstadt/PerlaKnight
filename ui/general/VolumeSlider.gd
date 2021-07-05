extends HSlider
class_name VolumeSlider

onready var Bus := AudioServer.get_bus_index(audio_bus_name)

export var audio_bus_name := "Master"

func _ready() -> void:
	value = db2linear(AudioServer.get_bus_volume_db(Bus))

func on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(Bus, linear2db(value))
