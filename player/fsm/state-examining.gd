extends PlayerState

# STATE:
# When the player is examining an hold item.
class_name State_Examining

func _init().("EXAMINING") -> void:
	pass

func enter():
	print("Examining now...")
	assert(player.is_holding_item())
	# TODO: add here moving the item in focus
	player.begin_item_examination()
	# TODO: 

func leave():
	print("Stop examining...")
	assert(player.is_holding_item())
	player.end_item_examination()

func update(delta):
	# TODO: code that allows turning the item around,
	# zooming on it etc.
	player.update_item_position(delta)
	
	if Input.is_action_just_pressed("item_examination"):
		state_machine.push_action(PlayerState.Action.stop_examining_item)

