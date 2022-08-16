extends FSM_StateMachine  # The state machine is also a state, making it a sub-state-machine.

# STATE:
# When the player can move around, look around and take/hold/drop items.
class_name State_Exploring

var player

func _init().("EXPLORING",
	{ # Transition table:
		FSM_StateMachine.START: "NO_ITEM",
		"NO_ITEM": { PlayerState.Action.take_item: "HOLDING_ITEM" },
		"HOLDING_ITEM": { PlayerState.Action.drop_item: "NO_ITEM" },
	}) -> void:
		pass
		
func enter():
	print("Exploring now...")
	.enter()

func leave():
	print("Stop exploring...")
	.leave()

func update(delta):
	player._update_walk(delta)
	.update(delta)

func input_update(event: InputEvent):
	player._update_orientation(event)
	.input_update(event)

