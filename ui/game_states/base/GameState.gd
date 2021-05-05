extends State
class_name GameState

func _ready() -> void:
	self.visible = false

func _state_enter(_previous_state: State, _params: Dictionary = {}) -> void:
	self.visible = true

func _state_process(_delta: float) -> void:
	pass

func _state_physics_process(_delta: float) -> void:
	pass

func _state_exit(_next_state: State) -> void:
	self.visible = false
