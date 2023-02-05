extends Area

class_name LockArea

signal unlocked(key_name)

var is_locked := true

# Name that the key must match to open this lock.
export(String) var lock_name : String

var key_slot: Spatial

export(NodePath) var path_to_key_slot

func _ready():
	set_collision_layer_bit(CollisionLayers.key_lock_collision_bit, true)
	set_collision_mask_bit(CollisionLayers.key_lock_collision_bit, true)
	connect("area_entered", self, "_on_area_entered")
	
	# get the key slot if any
	key_slot = _find_key_slot()
	assert(key_slot, "A Spatial must be specified")
	
	
func _on_area_entered(area: Area) -> void :
	if is_locked == false:
		return
#	print("checking area")
	# If the key area detected is matching our name, we unlock
	if not get_parent() == area.get_parent() and area is KeyArea and area.key_name == lock_name: 
		is_locked = false
		print("KEY MATCH! '%s' UNLOCKED" % lock_name)
		var item = ItemUtils.get_item_parent_node(area)
		assert(item)
		item.snap_to(key_slot)
		item.set_collision_layer_bit(CollisionLayers.key_lock_collision_bit, false)
		item.set_collision_mask_bit(CollisionLayers.key_lock_collision_bit, false)
		set_collision_layer_bit(CollisionLayers.key_lock_collision_bit, false)
		set_collision_mask_bit(CollisionLayers.key_lock_collision_bit, false)
		emit_signal("unlocked", lock_name)
		
func _find_key_slot() -> Spatial:
	var node = get_node_or_null(path_to_key_slot)
	assert(node is Spatial)
	return node as Spatial
	
