extends FSM_State # Both a Node and a state, to allow sub-statemachines

class_name FSM_StateMachine

const START := "INITIAL_STATE"

var _states:= {}
var _transition_table: Dictionary

var _current_state: FSM_State
var _next_state: FSM_State

var _current_transition: GDScriptFunctionState

# The transition table must be provided in the form:
#     { 
#         state_id : { action_id: state_id, ... }, 
#		  ... 
#     }
# The transition table must also have `start` id set to the id
# of the state that we must start with:
#     { FSM_StateMachine.START: state_id, ... }
# The start state will be entered immediately.
func _init(id: String, transition_table: Dictionary).(id):
	_transition_table = transition_table

func _ready():
	yield(owner, "ready")
	_gather_states()
	_begin_switch_to(_transition_table[START])
	
func _gather_states():
	for node in get_children():
		var node_id = node.state_id
		if node is FSM_State:
			assert(!_states.has(node_id), "Node type exists more than once in the state-machine children node: %s" % node_id)
			node.state_machine = self
			_states[node_id] = node

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

func _process(delta):
	_update_state_transition(delta)
	_current_state.update(delta)

func _physics_process(delta):
	_current_state.physics_update(delta)

func _input(event:InputEvent):
	_current_state.input_update(event)

func _unhandled_input(event:InputEvent):
	_current_state.unhandled_input_update(event)

func _begin_switch_to(state_id) -> void:
	assert(state_id is String)
	_next_state = _states[state_id]
	assert(_next_state is FSM_State)
	if(_current_state != null):
		_current_transition = _current_state.leave()
	else:
		# No transition: switch immediately
		_switch_to_next_state()
	
func _update_state_transition(delta):
	
	# Are we done with the current transition?
	if(_current_transition is GDScriptFunctionState && _current_transition.is_valid()):
		_current_transition = _current_transition.resume(delta)
		return # skip the rest until the transition is done
	
	# We are done, if we need to swap state do it now:
	if(_next_state != null):
		_switch_to_next_state()
	
func _switch_to_next_state():
	assert(_next_state is FSM_State)
	_current_state = _next_state
	_next_state = null
	_current_transition = _current_state.enter()
	
	

	
