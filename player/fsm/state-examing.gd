extends PlayerState

# STATE:
# When the player is examining an hold item.
class_name State_Examining

func _init().("EXAMINING"):
	pass

func enter():
	print("Examining now...")
	# TODO: add here moving the item in focus
	# TODO: 

func update(delta):
	# TODO: code that allows turning the item around,
	# zooming on it etc.
	pass
