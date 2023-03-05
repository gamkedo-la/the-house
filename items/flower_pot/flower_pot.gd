tool
extends InteractiveItem

export(float, 0.1, 100.0) var width := 1.0 setget _set_width
export(float, 0.1, 100.0) var height := 1.0 setget _set_height


func _update_scale() -> void:
	var new_scale = Vector3(width, height, width)
	$mesh.scale = new_scale
	$collision_shape.scale = new_scale

func _set_width(new_value : float) -> void:
	width = new_value
	_update_scale()
	
func _set_height(new_value : float) -> void:
	height = new_value
	_update_scale()





