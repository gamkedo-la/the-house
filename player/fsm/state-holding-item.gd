extends PlayerState

# STATE:
# When the player is holding an item.
# Note that in this state they are not examining it.
class_name State_HoldingItem

func _init().("HOLDING_ITEM"):
	pass
	
func enter():
	print("Took an item")
	# TODO: add here moving the item in focus

func update(delta):			
	# TODO: how to examine item
	# TODO: drop the hold item
	# TODO: activate/deactivate item
	# TODO: special lighter->candle detection here? maybe? maybe just the lighter code can do the thing
	pass
	
