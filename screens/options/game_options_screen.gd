extends CanvasLayer

onready var _toggle_crouch := $"%checkbox_toggle_crouch"
onready var _toggle_hold := $"%checkbox_toggle_hold"
onready var _toggle_running := $"%checkbox_toggle_running"
onready var _camera_mouse_slider := $"%camera_mouse_speed_slider"

func _ready() -> void:
	
	_toggle_crouch.pressed = options.toggle_crouch
	_toggle_crouch.connect("toggled", self, "_on_crouch_changed")
	
	_toggle_hold.pressed = options.toggle_hold
	_toggle_hold.connect("toggled", self, "_on_crouch_changed")
	
	_toggle_running.pressed = options.toggle_run
	_toggle_running.connect("toggled", self, "_on_run_changed")
	
	_camera_mouse_slider.value = options.mouse_camera_speed
	_camera_mouse_slider.connect("value_changed", self, "_on_camera_mouse_speed_changed")
	
	
func _on_crouch_changed(enabled: bool) -> void:
	options.toggle_crouch = enabled
	
func _on_hold_changed(enabled: bool) -> void:
	options.toggle_hold = enabled
	
func _on_run_changed(enabled: bool) -> void:
	options.toggle_run = enabled
	
func _on_camera_mouse_speed_changed(new_value: float) -> void:
	options.mouse_camera_speed = new_value
