extends MeshInstance

export var bob_size : float = 0.1
export var bob_freq : float = 4
export var breathing_bob_size : float = 0.01
export var breathing_bob_freq : float = 2.313

func _process(_delta):

	var time_since_beginning = OS.get_ticks_msec() * 0.001
	var pos = global_transform.origin
	var dist = pos.length()

	# breathing constantly up and down
	translation.y = sin(time_since_beginning * breathing_bob_freq) * breathing_bob_size

	# bob the child mesh up and down based on pos (fake footstep animation!)
	
	# fixme: if you move diagonally the two sin waves can cancel out and no bob
	# translation.y += sin((pos.x*bob_freq+pos.z*bob_freq)) * bob_size
	
	# fixme: if you circle strafe 0,0,0 you don't step (dist stays same)
	translation.y += sin(dist * bob_freq) * bob_size
