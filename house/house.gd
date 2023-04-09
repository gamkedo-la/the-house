extends Spatial


func _ready() -> void:
	var living_door = $"%living_door";
	living_door.connect("door_opened", self, "_on_living_door_open")
	living_door.connect("door_closed", self, "_on_living_door_closed")

func _on_living_door_open() -> void:
	var giant_mouth = $"%giant_mouth"
	giant_mouth.start_mumbling()

func _on_living_door_closed() -> void:
	var giant_mouth = $"%giant_mouth"
	giant_mouth.stop_mumbling()
