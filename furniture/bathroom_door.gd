tool
extends Door


func _ready():
	find_node("lock").connect("unlocked", self, "_on_weird_knob_locked_in")
	_setup_door_handle($interration_area)

func _on_weird_knob_locked_in(_key_name):
	_unsetup_door_handle($interration_area)
	$interration_area.visible = false
	$interration_area.set_deferred("monitoring", false)
	$interration_area.set_deferred("monitorable", false)
	var weird_knob = find_node("lock").get_node("knob_hole").get_node("weird_door_knob")
	assert(weird_knob)
	_setup_door_handle(weird_knob)
	unlock()






