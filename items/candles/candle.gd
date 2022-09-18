extends InteractiveItem

onready var light : Node = $"light"


func _on_lightable_area_lit_using_fire() -> void:
	print("time to turn on through fire")
	light_on()

func light_on() -> void:
	print("turning light on")
	light.show()
	
func light_off() -> void:
	print("turning light off")
	light.hide()
	
# TODO: add ways to make the candle turn off when mishandled
