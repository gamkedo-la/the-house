extends Area


# This is used to light candles etc.
class_name FireArea

var _is_fire_on := false

func _ready():
	set_collision_layer_bit(CollisionLayers.lighting_by_fire_collision_bit, true)

func is_fire_on() -> bool:
	return _is_fire_on

func on_fire_on() -> void:
#	print("fire area on")
	_is_fire_on = true
	
func on_fire_off() -> void:
#	print("fire area off")
	_is_fire_on = false
