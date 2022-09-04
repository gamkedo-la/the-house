extends FSM_State # Both a Node and a state, to allow sub-statemachines

class_name FSM_StateMachine

const START := "INITIAL_STATE"

var _states:= {}
var _transition_table: Dictionary

var _current_state: FSM_State
var _next_state: FSM_State
var is_active := false setget , get_is_active
func get_is_active():
	return is_active

var _current_transition: GDScriptFunctionState

func print_log(message: String) -> void:
	print("FSM(%s): %s" % [state_id , message] )

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
	_gather_states()

func start() -> void:
	is_active = true
	print_log("Starting... ")
	_begin_switch_to(_transition_table[START])
	
func _gather_states() -> void:
	for node in get_children():
		var node_id = node.state_id
		if node is FSM_State:
			assert(!_states.has(node_id), "Node type exists more than once in the state-machine children node: %s" % node_id)
			node.state_machine = self
			_states[node_id] = node
			print_log("FSM: Registered state: %s" % node_id)

# Takes an action id and look for a state to transition to following the
# transition table given in `_init()`.
func push_action(action_id, params:= {}) -> bool:
	assert(action_id != null)
	print_log("Received action: %s" % action_id)
	if !is_active:
		return false
	var current_state_transitions = _transition_table[_current_state.state_id]
	assert(current_state_transitions != null)
	var next_state_id = current_state_transitions.get(action_id)
	if next_state_id != null: # Can be null if nothing matches the action.
		print_log("Transition found for action: %s -> %s" % [action_id, next_state_id])
		_begin_switch_to(next_state_id)
		return true
	else:
		# Forward to parent state-machine if existing:
		var result = false
		if state_machine:
			result = state_machine.push_action(action_id)
			
		if result == false:
			 print_log("No transition found for action: %s" % action_id)
		return result

func _process(delta) -> void:
	if !is_active:
		return
	_update_state_transition(delta)
	_current_state.update(delta)

func _physics_process(delta) -> void:
	if !is_active:
		return
	_current_state.physics_update(delta)

func _input(event:InputEvent) -> void:
	if !is_active:
		return
	_current_state.input_update(event)

func _unhandled_input(event:InputEvent) -> void:
	if !is_active:
		return
	_current_state.unhandled_input_update(event)

func _begin_switch_to(next_state_id: String) -> void:
	_next_state = _states[next_state_id]
	assert(_next_state is FSM_State)
	
	if(_current_state is FSM_State):
		print_log("Leaving %s ..." % _current_state.state_id)
		_current_transition = _current_state.leave()
		
	if(_current_transition == null || _current_state == null):
		# No transition: switch immediately
		_switch_now_to_next_state()
		
func _update_state_transition(delta) -> void:
	
	# Are we done with the current transition?
	if(_current_transition is GDScriptFunctionState && _current_transition.is_valid()):
		_current_transition = _current_transition.resume(delta)
		return # skip the rest until the transition is done
	
	# We are done, if we need to swap state do it now:
	if(_next_state != null):
		_switch_now_to_next_state()
	
func _switch_now_to_next_state() -> void:
	assert(_next_state is FSM_State)
	_current_state = _next_state
	_next_state = null
	print_log("Entering %s ...." % _current_state.state_id)
	_current_transition = _current_state.enter()
	
func enter():
	print_log("State machine %s activates..." % state_id)
	is_active = true
	if _next_state == null:
		start()
		
func leave():
	print_log("State machine %s deactivates..." % state_id)
	is_active = false
	


	
