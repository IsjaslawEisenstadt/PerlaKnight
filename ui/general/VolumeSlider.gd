extends HSlider
class_name VolumeSlider

onready var Bus := AudioServer.get_bus_index(audio_bus_name)

export var audio_bus_name := "Master"

func _ready() -> void:
	value = Config.get_volume(audio_bus_name, db2linear(AudioServer.get_bus_volume_db(Bus)))
	connect("visibility_changed", self, "on_visibility_changed")

func on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(Bus, linear2db(value))
	Config.set_volume(audio_bus_name, value)

func on_visibility_changed() -> void:
	value = Config.get_volume(audio_bus_name, db2linear(AudioServer.get_bus_volume_db(Bus)))
