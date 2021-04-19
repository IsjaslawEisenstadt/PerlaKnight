extends State
class_name CharacterState

"""
base state for the CharacterStateMachine, provides the host to all character states
"""

# host isn't optional and has to be a character
onready var host := get_node(host_path) as Character

export var host_path: NodePath = "../../.."

func _ready() -> void:
	assert(host)

func _can_interact() -> bool:
	return true
