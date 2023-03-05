extends Node

class_name ItemUtils


# Find the node in the parent hierarchy which is an InteractiveItem 
static func get_item_parent_node(node: Node) -> InteractiveItem:
	if node == null:
		return null
	
	if node is InteractiveItem:
		return node as InteractiveItem
	
	return get_item_parent_node(node.get_parent())

static func has_fire_area(node: Node) -> bool:
	if node is FireArea:
		return true
		
	for child in node.get_children():
		if has_fire_area(child):
			return true
			
	return false
