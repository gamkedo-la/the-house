extends PlayerState

# STATE:
# When the player is not holding any item.
class_name State_NoItem

func _init().("NO_ITEM"):
	pass

func enter():
	if player.is_holding_item():
		player.drop_item()

	print("No item in hands")

func physics_update(delta: float):
	player.exploration_update(delta)

func update(_delta: float):
	
	if Input.is_action_just_pressed("take_pointed_item") and player.is_pointing_takable_item():
		state_machine.push_action(PlayerState.Action.take_item)
		
func input_update(event: InputEvent):
	player.exploration_input_handling(event)
