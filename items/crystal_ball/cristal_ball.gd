extends InteractiveItem

onready var _light_node : OmniLight = $"light"
onready var _sphere_node : CSGSphere = $"sphere"

func _ready():
	turn_off()

func is_lighting() -> bool:
	return _light_node.visible

func turn_on() -> void:
	_sphere_node.material.emission_enabled = true
	_light_node.visible = true
	
func turn_off() -> void:
	_sphere_node.material.emission_enabled = false
	_light_node.visible = false
	
func switch_light() -> void:
	if is_lighting():
		turn_off()
	else:
		turn_on()

func _on_crystal_ball_use_item(_item) -> void:
	switch_light()
