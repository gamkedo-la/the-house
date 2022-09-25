extends CPUParticles


onready var base_gravity = gravity.length()

func _physics_process(delta):
	# is there an easier way to get the global up vector in local space?
	var local_up = (to_local(Vector3.UP) - to_local(Vector3.ZERO)).normalized()
	gravity = base_gravity * local_up
