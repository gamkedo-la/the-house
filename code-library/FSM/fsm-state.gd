extends Node 

# Base node for a state in a state machine.
# State implementations must inherit this type to be injected in the state
# machine (FSM_StateMachine)
class_name FSM_State

# The current state machine this state is in.
# This is destined to be set only by the state machine itself.
# Then other code can use it to call `state_machine.push_action(...)`
onready var state_machine # : FSM_StateMachine  # not set because of cycle in dependencies

var state_id : String setget , get_state_id

func _init(id: String) -> void:
	assert(!id.empty())
	state_id = id

func get_state_id() -> String:
	return state_id

# Called when the state-machine starts this state. Overrides if you need
# to execute code as part of the transition to this state.
# We are in this state as soon as the first call to this function.
# If the implementation is a coroutine (returns GDScriptFunctionState),
# the execution will happen in parallel of the update functions to allow 
# implementing smooth transitions through multiple updates.
func enter():
	pass

# Called when the state-machine switches to another state. Overrides if you need
# to execute code as part of the transition out of this state.
# This function must end before the statemachine consider the current state done.
# If the implementation is a coroutine (returns GDScriptFunctionState),
# the execution will happen in parallel of the update functions to allow 
# implementing smooth transitions through multiple updates.
func leave():
	pass

# Called every frame update by the state-machine if this is the current state.
func update(_delta: float) -> void:
	pass

# Called every frame update by the state-machine if this is the current state.
func physics_update(_delta: float) -> void:
	pass

# Called at input events.
func input_update(_event:InputEvent) -> void:
	pass

# Called when an input event wasn't handled.
func unhandled_input_update(_event:InputEvent) -> void:
	pass
