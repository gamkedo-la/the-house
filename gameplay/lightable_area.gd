extends Area

class_name LightableArea

# This class is only for areas in which a flame would light this item

signal lit_using_fire

func _ready():
	set_collision_layer_bit(CollisionLayers.lighting_by_fire_collision_bit, true)
	set_collision_mask_bit(CollisionLayers.lighting_by_fire_collision_bit, true)
	connect("area_entered", self, "_on_area_entered")

func light_using_fire() -> void :
#	print("lit my fire!")
	emit_signal("lit_using_fire")
	
func _on_area_entered(area: Area) -> void :
#	print("checking area")
	# If the lighter's lighting area is detected, we light this (if not already lit)
	if not get_parent() == area.get_parent() and area is FireArea and area.is_fire_on(): 
		light_using_fire()

