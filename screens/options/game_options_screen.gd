extends CanvasLayer

onready var _toggle_crouch := $"%checkbox_toggle_crouch"
onready var _toggle_hold := $"%checkbox_toggle_hold"
onready var _toggle_running := $"%checkbox_toggle_running"
onready var _camera_mouse_slider := $"%camera_mouse_speed_slider"

func _ready() -> void:
	
	_toggle_crouch.pressed = options.toggle_crouch
	_toggle_crouch.connect("toggled", self, "_on_crouch_changed")
		
	
	
func _on_crouch_changed(enabled: bool) -> void:
	options.toggle_crouch = enabled
	
	
