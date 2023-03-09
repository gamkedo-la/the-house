tool
extends Door


func _ready() -> void:
	connect("door_opened", self, "_on_door_opened")
	find_node("lock").connect("unlocked", self, "_on_lock_unlocked")
	
func _on_door_opened()-> void:
	$"../../basement_ladder".visible = true

func _on_lock_unlocked(_keyname) -> void:
	unlock()
 
