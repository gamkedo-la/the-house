extends PlayerState

# STATE:
# When the player is not holding any item.
class_name State_NoItem

func _init().("NO_ITEM"):
	pass

func enter():
	print("No item in hands")

func update(delta):
	# TODO: how to take item
	pass
