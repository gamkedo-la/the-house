extends Node

class_name ItemUtils

const key_lock_collision_bit := 9
const lighting_by_fire_collision_bit := 10


# Find the node in the parent hierarchy which is an InteractiveItem 
static func get_item_parent_node(node: Node) -> InteractiveItem:
	if node == null:
		return null
	
	if node is InteractiveItem:
		return node as InteractiveItem
	
	return get_item_parent_node(node.get_parent())

