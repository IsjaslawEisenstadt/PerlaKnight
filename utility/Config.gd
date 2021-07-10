extends Node

const CONFIG_PATH: String = "user://PerlaKnight.cfg"

var config: ConfigFile = ConfigFile.new()

func _ready() -> void:
	config.load(CONFIG_PATH)

func get_volume(bus_name: String, default: float = 0.0) -> float:
	return config.get_value("audio", bus_name, default)

func set_volume(bus_name: String, volume: float) -> void:
	config.set_value("audio", bus_name, volume)
	var err: int = config.save(CONFIG_PATH)
	assert(err == OK)
