extends Area


class_name FireArea

var _is_fire_on := false

# This is used to light candles etc.
const lighting_by_fire_collision_bit := 10
const fire_on_signal_name := "fire_is_on"
const fire_off_signal_name := "fire_is_on"

func _ready():
	get_parent().has_signal("")
	set_collision_layer_bit(lighting_by_fire_collision_bit, true)

func is_fire_on() -> bool:
	return _is_fire_on

func on_fire_on() -> void:
	print("fire area on")
	_is_fire_on = true
	
func on_fire_off() -> void:
	print("fire area off")
	_is_fire_on = false
