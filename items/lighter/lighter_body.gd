extends Spatial

onready var AnimationPlayer = get_parent().get_node("AnimationPlayer")

var is_on = false
onready var fire_area : Area = $"../Flame/fire_area"

func toggle_light():
	if is_on:
		turn_off()
	else:
		turn_on()

func turn_on():
	is_on = true
	AnimationPlayer.play("Open Lid")
	AnimationPlayer.queue("Light")
	AnimationPlayer.queue("Light Flickering")
	fire_area.on_fire_on()

func turn_off():
	is_on = false
	AnimationPlayer.play("Close Lid")
	fire_area.on_fire_off()

func _on_lighter_use_item(_lighter):
	toggle_light()
