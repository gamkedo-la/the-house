extends FSM_StateMachine

class_name PlayerStateMachine

# Player State machine:
# The following code is there so that we can put behavior
# that is specific to some state, like when we are examining
# an item vs when we are moving around. There are also
# sub-states like some things can only happen when we are holding
# an item. All the other code that should always be executed
# must go in the other normal node functions (_process and _physics_process).

func _init(player).("PLAYER_STATE_MACHINE",
	{ # Transition table:
		FSM_StateMachine.START: "State_Exploring",
		"State_Exploring": { Player.Action.examine_item: "State_Examining" },
		"State_Examining": { Player.Action.stop_examining_item: "State_Exploring" },
	}):
		pass
