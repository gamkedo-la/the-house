
extends FSM_State
class_name FSM_StateMachine

enum { START }

var _states: Dictionary
var _transition_table: Dictionary

class StateSlot:
	var state : FSM_State
	var id

	func _init(id_, state_ : FSM_State):
		assert(id_ != null)
		assert(state != null)
		id = id_
		state = state_

var _current_state: StateSlot
var _next_state: StateSlot

var _current_transition: GDScriptFunctionState

# The states must be provided in the form:
#     { state_id: state_instance , ... }
#
# The transition table must be provided in the form:
#     { 
#         state_id : { action_id: state_id, ... }, 
#		  ... 
#     }
# The transition table must also have `start` id set to the id
# of the state that we must start with:
#     { FSM_StateMachine.START: state_id, ... }
# The start state will be entered immediately.
func _init(states: Dictionary, transition_table: Dictionary):
	# TODO: add some checks here
	_states = states
	_transition_table = transition_table
	_begin_switch_to(_transition_table[START])

# Takes an action id and look for a state to transition to following the
# transition table given in `_init()`.
func push_action(action_id, params:= {}) -> bool:
	var current_state_transitions = _transition_table[_current_state.id]
	assert(current_state_transitions != null)
	var next_state_id = current_state_transitions[action_id]
	if(next_state_id != null): # Can be null if nothing matches the action.
		_begin_switch_to(next_state_id)
		return true
	else:
		return false


func update(delta):
	_update_state_transition(delta)
	_current_state.update(delta)

func physics_update(delta):
	_current_state.physics_update(delta)

func input_update(event:InputEvent):
	_current_state.input_update(event)

func _begin_switch_to(state_id) -> void:
	assert(state_id != null)
	_next_state = StateSlot.new(state_id, _states[state_id])
	assert(_next_state != null)
	if(_current_state != null):
		_current_transition = _current_state.state.leave()
	
func _update_state_transition(delta):
	
	# Are we done with the current transition?
	if(_current_transition is GDScriptFunctionState && _current_transition.is_valid()):
		_current_transition = _current_transition.resume(delta)
		return # skip the rest until the transition is done
	
	# We are done, if we need to swap state do it now:
	if(_next_state != null):
		_current_state = _next_state
		_next_state = null
		_current_transition = _current_state.state.enter()
	

	
	

	
