tool
extends Door

func _ready() -> void:
	connect("door_unlocked", self, "_on_door_unlocked")
	connect("door_locked", self, "_on_door_locked")
	lock()
	
func _on_door_unlocked()-> void:
	var ladder = get_node_or_null("../../attic_ladder")
	if ladder:
		ladder.visible = true

func _on_door_locked()-> void:
	var ladder = get_node_or_null("../../attic_ladder")
	if ladder:
		ladder.visible = false
 
