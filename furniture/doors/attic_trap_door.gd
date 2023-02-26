tool
extends Door


func _ready() -> void:
	connect("door_unlocked", self, "_on_door_unlocked")
	
func _on_door_unlocked()-> void:
	$"../../attic_ladder".visible = true

 
