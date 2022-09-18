extends InteractiveItem

onready var light : Node = $"light"


func _on_light_lit_using_fire() -> void:
	light.visible = true
	
