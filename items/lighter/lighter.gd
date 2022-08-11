extends Spatial

onready var AnimationPlayer = get_parent().get_node("AnimationPlayer")

var toggle = false
		
func toggle_light():
	if toggle:
		toggle = false
		turn_off()
	else:
		toggle = true
		turn_on()

func turn_on():
	AnimationPlayer.play("Open Lid")
	AnimationPlayer.queue("Light")
	AnimationPlayer.queue("Light Flickering")
	pass
	
func turn_off():
	AnimationPlayer.play("Close Lid")
	pass


func _on_lighter_use_item():
	toggle_light()
