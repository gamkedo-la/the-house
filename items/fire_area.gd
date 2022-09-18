extends Area


class_name FireArea

# This is used to light candles etc.
const lighting_by_fire_collision_bit = 10

func _ready():
	set_collision_layer_bit(lighting_by_fire_collision_bit, true)

func is_fire_on() -> bool:
	return self.is_visible_in_tree()
