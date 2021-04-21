extends InputController
class_name AIInputController

"""
InputController for all AI states, holds a state machine for AI scripts
the idea is that the current AI script (de)activates actions with the InputController
and the CharacterController retrieves those with the virtual InputController functions.
"""

enum action_states {ACTIVE, INACTIVE, ACTIVATED, DEACTIVATED}

export var start_ai: NodePath = "WaitAI"

var action_map: Dictionary = {}
var state_machine: AIStateMachine

# action mapping

func activate_action(action: String) -> void:
	action_map[action] = action_states.ACTIVATED

func deactivate_action(action: String) -> void:
	action_map[action] = action_states.DEACTIVATED

func deactivate_actions() -> void:
	for action in action_map.keys():
		action_map[action] = action_states.DEACTIVATED

# virtual functions from InputController

# starts the ai state machine (called from character)
func _start(host) -> void:
	state_machine = AIStateMachine.new()
	state_machine.host = host
	state_machine.input_controller = self
	state_machine._push_state(get_node(start_ai))

# called from the charactercontroller as well
func _input_process(delta: float) -> void:
	# every key should be deactivated after a frame
	# TODO: check how physics_process relates to this
	for action in action_map.keys():
		if action_map[action] == action_states.ACTIVATED:
			action_map[action] = action_states.ACTIVE
		elif action_map[action] == action_states.DEACTIVATED:
			action_map[action] = action_states.INACTIVE

	state_machine._state_machine_process(delta)

func _is_action_active(name: String) -> bool:
	var value = action_map.get(name)
	return value == action_states.ACTIVE || value == action_states.ACTIVATED

func _is_action_just_activated(name: String) -> bool:
	return action_map.get(name) == action_states.ACTIVATED

func _is_action_just_deactivated(name: String) -> bool:
	return action_map.get(name) == action_states.DEACTIVATED
