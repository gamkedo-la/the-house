extends FSM_StateMachine

class_name PlayerStateMachine

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


#func _init(player).({
#		State_Exploring: State_Exploring.new(player),
#		State_Examining: State_Examining.new(player),
#	},
#	{ # Transition table:
#		FSM_StateMachine.START: State_Exploring,
#		State_Exploring: {
#			Action.examine_item: State_Examining,
#		},
#		State_Examining: {
#			Action.stop_examining_item: State_Exploring,
#		}
#	})


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



#############################################################################################################
#
## Player State machine:
## The following code is there so that we can put behavior
## that is specific to some state, like when we are examining
## an item vs when we are moving around. There are also
## sub-states like some things can only happen when we are holding
## an item. All the other code that should always be executed
## must go in the other normal node functions (_process and _physics_process).
#
## Higher level actions the player can do, used to change the states:
#enum Action { take_item, drop_item, examine_item, stop_examining_item }
#
## Shortcut type for making states accessing the player instance.
#class PlayerState:
#	extends FSM_State
#
#	var player: Player
#
#	func _init(player_: Player):
#		player = player_
#		._init()
#
### Player States: ####
#
## When the player can move around, look around and take/hold/drop items.
#class State_Exploring:
#	extends FSM_StateMachine # The state machine is also a state, making it a sub-state-machine.
#	var player: Player
#
#	func _init(player_: Player):
#		player = player_
#		._init({
#			State_FreeHands: State_FreeHands.new(player_),
#			State_HoldingItem: State_HoldingItem.new(player_),
#		},
#		{	# Transition table:
#			FSM_StateMachine.START: State_FreeHands,
#			State_FreeHands: {
#				Action.take_item: State_HoldingItem,
#			},
#			State_HoldingItem: {
#				Action.drop_item: State_HoldingItem,
#			},
#		})
#
#	func enter():
#		print("Exploring now...")
#		player.is_movement_enabled = true
#		.enter()
#
#	func leave():
#		print("Stop exploring...")
#		player.is_movement_enabled = false
#		.leave()
#
#	func update(delta):
#		player._update_walk(delta)
#		.update(delta)
#
#	func input_update(event: InputEvent):
#		player._update_orientation(event)
#		.input_update(event)
#
#	# When the player is not holding any item.
#	class State_FreeHands:
#		extends PlayerState
#
#		func enter():
#			print("Hands are free!")
#
#		func update(delta):
#			# TODO: how to take item
#			pass
#
#	# When the player is holding an item.
#	class State_HoldingItem:
#		extends PlayerState
#
#		func enter():
#			print("Took an item")
#			# TODO: add here moving the item in focus
#
#		func update(delta):			
#			# TODO: how to examine item
#			# TODO: drop the hold item
#			# TODO: activate/deactivate item
#			# TODO: special lighter->candle detection here? maybe? maybe just the lighter code can do the thing
#			pass
#
#
#
## When the player is examining an hold item.
#class State_Examining:
#	extends PlayerState
#
#	func enter():
#		print("Examining now...")
#		# TODO: add here moving the item in focus
#		# TODO: 
#
#	func update(delta):
#		# TODO: code that allows turning the item around,
#		# zooming on it etc.
#		pass

