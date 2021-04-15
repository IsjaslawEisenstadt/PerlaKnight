extends Node
class_name StateMachine

"""
base class for all state machines
uses a stack structure where the uppermost state is the current state
the state stack can be accessed directly or by the push & pop functions provided (preferred)
every state machine can override the functions of this class to extend their functionality
"""

var state_stack: Array = []

# pushes a given state onto the state stack, works with an empty stack as well
# this function is useful for overrides because you can alter the variables of the next state
# before calling ._push_state(next_state) without worrying about stack management
func _push_state(next_state: State, params = null) -> bool:
	if !next_state:
		return false
	next_state.state_machine = self
	var current_state: Node
	if !state_stack.empty():
		current_state = state_stack.front()
		current_state._state_exit(next_state)
	state_stack.push_front(next_state)
	next_state._state_enter(current_state, params)
	return true

# function to remove the uppermost state on the stack
func _pop_state(params = null) -> void:
	assert(!state_stack.empty())

	var current_state: Node = state_stack.front()
	state_stack.pop_front()
	current_state._state_exit(null if state_stack.empty() else state_stack.front())
	if !state_stack.empty():
		state_stack.front()._state_enter(current_state, params)

# a convenience function pop the current state and push the given state afterwards
# it's useful to allow a sequence of states that return to the last state before this sequence
# (see JumpState.gd/FallState.gd for usage examples)
func _pop_push(next_state: State, params = null) -> bool:
	assert(!state_stack.empty())

	var current_state: State = state_stack.front()
	if _push_state(next_state, params):
		state_stack.erase(current_state)
		return true
	return false

# these two functions have to be called from somewhere,
# usually from the state machines owner or the state machine itself
func _state_machine_process(delta: float):
	if !state_stack.empty():
		state_stack.front()._state_process(delta)

func _state_machine_physics_process(delta: float):
	if !state_stack.empty():
		state_stack.front()._state_physics_process(delta)

# Returns the uppermost state of the stack which corresponds to the current state
func get_current_state() -> State:
	if state_stack.empty():
		return null
	else:
		return state_stack.front()
