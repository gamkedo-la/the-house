extends Area

class_name LightableArea

# This class is only for areas in which a flame would light this item

signal lit_using_fire

func light_using_fire() -> void :
	emit_signal("lit_using_fire")
	
func area_entered(area: Area) -> void :
	# If the lighter's lighting area is detected, we light this (if not already lit)
	if not area.has_node("..") and area is FireArea: 
		light_using_fire()

