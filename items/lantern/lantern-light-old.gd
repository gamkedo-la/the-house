extends Spatial


var is_on = false
onready var light_source := $"./light_source"

func turn_on():
	is_on = true
	light_source.visible = true

func turn_off():
	is_on = false
	light_source.visible = false

func _on_lantern_use_item(_lantern):
	turn_off()


func _on_LightableArea_lit_using_fire():
	turn_on()
