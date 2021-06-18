extends InputController
class_name AIController

"""
InputController for all AI states, holds a state machine for AI scripts
the idea is that the current AI script (de)activates actions with the InputController
and the CharacterController retrieves those with the virtual InputController functions.
"""

enum action_states {ACTIVE, INACTIVE, ACTIVATED, DEACTIVATED}

onready var Host := get_node(host_path) as Character

export var host_path: NodePath = ".."

var action_map: Dictionary = {}

func _input_process(_delta: float) -> void:
	# every key should be deactivated after a frame
	for action in action_map.keys():
		if action_map[action] == action_states.ACTIVATED:
			action_map[action] = action_states.ACTIVE
		elif action_map[action] == action_states.DEACTIVATED:
			action_map[action] = action_states.INACTIVE

# action mapping

func activate_action(action: String) -> void:
	action_map[action] = action_states.ACTIVATED

func deactivate_action(action: String) -> void:
	action_map[action] = action_states.DEACTIVATED

func deactivate_actions() -> void:
	for action in action_map.keys():
		action_map[action] = action_states.DEACTIVATED

# virtual functions from InputController

func _is_action_active(name: String) -> bool:
	var value = action_map.get(name)
	return value == action_states.ACTIVE || value == action_states.ACTIVATED

func _is_action_just_activated(name: String) -> bool:
	return action_map.get(name) == action_states.ACTIVATED

func _is_action_just_deactivated(name: String) -> bool:
	return action_map.get(name) == action_states.DEACTIVATED
