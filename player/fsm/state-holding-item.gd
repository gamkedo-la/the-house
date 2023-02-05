extends PlayerState

# STATE:
# When the player is holding an item.
# Note that in this state they are not examining it.
class_name State_HoldingItem

func _init().("HOLDING_ITEM"):
	pass
	
func enter():
	if not player.is_holding_item():
		_take_pointed_item()
	print("Holding an item")

	
func update(delta):
	assert(player.is_holding_item())
	
	if Input.is_action_just_pressed("drop_held_item"):
		state_machine.push_action(PlayerState.Action.drop_item)
	
	# We allow taking another item even if we have one already, just swap them
	if Input.is_action_just_pressed("interract_with_pointed_entity"):
		if player.is_pointing_takable_item():
			_take_pointed_item()
		elif player.is_pointing_usable_entity():
			player.use_pointed_usable_entity()
		
		
	if Input.is_action_just_pressed("item_activation"):
		player.use_item()

	if Input.is_action_just_pressed("item_examination"):
		state_machine.push_action(PlayerState.Action.examine_item)
		
	if Input.is_action_just_pressed("item_center_holding"):
		player.begin_center_item_holding()
		
	if Input.is_action_just_released("item_center_holding"):
		player.end_center_item_holding()
	
func input_update(event: InputEvent):
	player.exploration_input_handling(event)
	
func physics_update(delta: float):
	player.exploration_update(delta)

	
func _take_pointed_item() -> void:
	var pointed_item = player.get_currently_pointed_item()
	assert(pointed_item is InteractiveItem)
	assert(pointed_item.is_takable_now())
	
	if player.is_holding_item():
		player.drop_item()
		
	player.take_item(pointed_item)
	assert(player.is_holding_item())
	
