extends Spatial

onready var AnimationPlayer = get_node("AnimationPlayer")

var toggle = false

func _ready():
	pass

func _process(delta):
	if Input.is_key_pressed(KEY_Q):
		toggle_light()
		
func toggle_light():
	if AnimationPlayer.is_playing():
		return
	if toggle:
		toggle = false
		turn_off()
	else:
		toggle = true
		turn_on()

func turn_on():
	AnimationPlayer.play("Open Lid")
	AnimationPlayer.queue("Light")
	pass
	
func turn_off():
	AnimationPlayer.play_backwards("Open Lid")
	AnimationPlayer.queue("RESET")
	pass
