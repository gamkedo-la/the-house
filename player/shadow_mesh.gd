extends MeshInstance

var bob_size = 0.1
var bob_freq = 4
var breathing_bob_size = 0.05
var breathing_bob_freq = 1
var age = 0


func _process(delta):

	age += delta
	var pos = global_transform.origin
	var dist = pos.length()

	# breathing constantly up and down
	translation.z = sin(age*breathing_bob_freq)*breathing_bob_size

	# bob the child mesh up and down based on pos (fake footstep animation!)
	
	# fixme: if you move diagonally the two sin waves can cancel out and no bob
	# translation.z += sin((pos.x*bob_freq+pos.z*bob_freq)) * bob_size
	
	# fixme: if you circle strafe 0,0,0 you don't step (dist stays same)
	translation.z += sin(dist*bob_freq) * bob_size
