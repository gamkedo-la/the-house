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
	AnimationPlayer.play("Switch On")
	
func turn_off():
	AnimationPlayer.play("Switch Off")

func _on_torch_use_item():
	toggle_light()
