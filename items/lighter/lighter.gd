extends Spatial

onready var AnimationPlayer = get_node("AnimationPlayer")

var toggle = false

func _ready():
	pass

func _input(event):
	if event is InputEventKey and event.scancode == KEY_Q and event.pressed and not event.echo:
		toggle_light()
		
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
