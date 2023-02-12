tool
extends RigidBody


export var is_left_handed : bool = false setget _set_left_handed,_is_left_handed


func _set_left_handed(new_value: bool) -> void:
	if is_left_handed != new_value:
		scale = scale * Vector3(-1.0, 1.0, 1.0)
	is_left_handed = new_value
	
func _is_left_handed() -> bool:
	return is_left_handed
