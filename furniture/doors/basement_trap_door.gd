tool
extends Door


func _ready() -> void:
	connect("door_opened", self, "_on_door_opened")
	
func _on_door_opened()-> void:
	$"../../basement_ladder".visible = true

 
