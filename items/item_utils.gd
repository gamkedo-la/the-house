extends Node

class_name ItemUtils


# Find the node in the parent hierarchy which is an InteractiveItem 
static func get_item_parent_node(node: Node) -> InteractiveItem:
	if node == null:
		return null
	
	if node is InteractiveItem:
		return node as InteractiveItem
	
	return get_item_parent_node(node.get_parent())
