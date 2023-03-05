extends Area

# This is used for matching keys and locks.
# Note that here "key" and "lock" describes the functionality, not the look.
class_name KeyArea

# Key name, must match the name of the lock area
export(String) var key_name : String

onready var item := ItemUtils.get_item_parent_node(get_parent())

func _ready():
	set_collision_layer_bit(CollisionLayers.key_lock_collision_bit, true)
	

func get_class() -> String:
	return "KeyArea"
