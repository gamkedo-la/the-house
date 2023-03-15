tool
extends InteractiveItem

class_name BodyHand

export var is_left_handed : bool = false setget _set_left_handed,_is_left_handed


func _set_left_handed(new_value: bool) -> void:
	if is_left_handed != new_value:
		for child_node in get_children():
			if child_node is Spatial:
				child_node.scale = child_node.scale * Vector3(-1.0, 1.0, 1.0)
	is_left_handed = new_value
	
func _is_left_handed() -> bool:
	return is_left_handed
