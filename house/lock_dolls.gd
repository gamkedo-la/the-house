extends LockArea

func _ready():
	connect("unlocked", self, "_on_release_key")
	
func _on_release_key(_key_name) -> void:
	var boot = $"%old_big_boot"
	assert(boot is InteractiveItem)
	boot.sleeping = false
	boot.mode = RigidBody.MODE_RIGID
	boot.linear_velocity = global.gravity
	boot.can_be_taken = true
	boot.visible = true
