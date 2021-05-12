extends StateMachine
class_name GameStateMachine

# save files can become incompatible over time, with breaking changes being a real possibility.
# a version number saved in these files will give us the chance to not read old save data
# in order to ensure proper functionality, especially during active development
const CURRENT_SAVE_VERSION: int = 1

export var start_state_path: NodePath = "ScreenSpaceUI/MainMenu"
export var save_file_path: String = "user://PerlaKnight.save"

func _ready() -> void:
	var start_state := get_node(start_state_path) as GameState
	assert(start_state)
	_push_state(start_state, load_game())

func _process(delta: float) -> void:
	_state_machine_process(delta)

func _physics_process(delta: float) -> void:
	_state_machine_physics_process(delta)

func save_game() -> void:
	var save_data := {}
	
	var current_level: Level = $PlayState.current_level
	# no reason to save when there's no active level around
	if !current_level:
		printerr('Tried to save without a current level!')
		return
	
	save_data["version"] = CURRENT_SAVE_VERSION
	save_data["current_level"] = current_level.filename
	
	current_level.save_game(save_data)
	
	var save_file := File.new()
	var err: int = save_file.open(save_file_path, File.WRITE)
	assert(!err, "Error opening Save File")
	
	save_file.store_string(JSON.print(save_data, "\t"))
	save_file.close()

func load_game() -> Dictionary:
	var save_file := File.new()
	var err: int = save_file.open(save_file_path, File.READ)
	if err:
		return {}
	var save_data: Dictionary = parse_json(save_file.get_as_text())
	if !"version" in save_data || save_data.version != CURRENT_SAVE_VERSION:
		return {}
	return {"save_data": save_data}
