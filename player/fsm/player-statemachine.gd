extends FSM_StateMachine

class_name PlayerStateMachine

# Player State machine:
# The following code is there so that we can put behavior
# that is specific to some state, like when we are examining
# an item vs when we are moving around. There are also
# sub-states like some things can only happen when we are holding
# an item. All the other code that should always be executed
# must go in the other normal node functions (_process and _physics_process).

func _init().("PLAYER_STATE_MACHINE",
	{ # Transition table:
		FSM_StateMachine.START: "NO_ITEM",
		"NO_ITEM": { PlayerState.Action.take_item: "HOLDING_ITEM" },
		"HOLDING_ITEM": {
			PlayerState.Action.drop_item: "NO_ITEM",
			PlayerState.Action.examine_item: "EXAMINING",
		},
		"EXAMINING": { PlayerState.Action.stop_examining_item: "HOLDING_ITEM", }
	}) -> void:
		pass

func start_with_player(player) -> void:
	set_player_to_all_states(player, self as FSM_StateMachine)
	start()

static func set_player_to_all_states(player, state_machine : FSM_StateMachine) -> void:
	for state_node in state_machine.get_children():
		assert(state_node is FSM_State)
		state_node.player = player
		if state_node is FSM_StateMachine:
			set_player_to_all_states(player, state_node as FSM_StateMachine)


