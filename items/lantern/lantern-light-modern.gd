extends Spatial


var is_on = false
onready var light_source : OmniLight = $"./light"

func toggle_light():
	if is_on:
		turn_off()
	else:
		turn_on()

func turn_on():
	is_on = true
	light_source.visible = true
	
func turn_off():
	is_on = false
	light_source.visible = false

func _on_lantern_use_item(_lantern):
	toggle_light()
