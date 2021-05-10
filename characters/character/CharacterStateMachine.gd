extends StateMachine
class_name CharacterStateMachine

onready var StartState := get_node(start_state_path) as State
onready var DeathState := get_node_or_null(death_state_path) as State
onready var HurtState := get_node_or_null(hurt_state_path)

export var start_state_path: NodePath = "IdleState"
export var death_state_path: NodePath = "DeathState"
export var hurt_state_path: NodePath = "HurtState"

func _push_state(next_state: State, params: Dictionary = {}) -> bool:
	assert(!next_state || next_state is CharacterState)
	return ._push_state(next_state, params)

func start() -> void:
	var start_success = _push_state(StartState)
	assert(start_success)

func die() -> bool:
	return _push_state(DeathState)

func hurt(attacker: Node2D) -> bool:
	return _push_state(HurtState,{"attacker": attacker})
