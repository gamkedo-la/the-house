extends InteractiveItem

onready var _light : Node = $"light"
onready var _fire_area : Node = $"light/Flame/fire_area"

func light_on() -> void:
	print("turning light on")
	_light.show()
	_fire_area.on_fire_on()
	
func light_off() -> void:
	print("turning light off")
	_light.hide()
	_fire_area.on_fire_off()
	
# TODO: add ways to make the candle turn off when mishandled



func _on_lightable_area_lit_using_fire() -> void:
	print("time to turn on through fire")
	light_on()


func _on_Candle_use_item():
	light_off()
	
