extends CanvasLayer

onready var _toggle_fullscreen := $"%toggle_fullscreen"
onready var _toggle_vsync := $"%toggle_vsync"
onready var _toggle_pixelated := $"%toggle_pixelated"
onready var _slider_fov := $"%slider_fov_angle"

func _ready() -> void:
	
	if OS.get_name() == "HTML5":
		_toggle_fullscreen.disabled = true
	_toggle_fullscreen.pressed = options.fullscreen
	_toggle_fullscreen.connect("toggled", self, "_on_fullscreen_changed")
	
	_toggle_vsync.pressed = options.vsync
	_toggle_vsync.connect("toggled", self, "_on_vsync_changed")
	
	_toggle_pixelated.pressed = options.pixelated
	_toggle_pixelated.connect("toggled", self, "_on_pixelated_changed")
	
	_slider_fov.value = options.fov
	_slider_fov.connect("value_changed", self, "_on_fov_changed")
	
	
func _on_fullscreen_changed(enabled: bool) -> void:
	options.fullscreen = enabled
	
func _on_vsync_changed(enabled: bool) -> void:
	options.vsync = enabled
	
func _on_pixelated_changed(enabled: bool) -> void:
	options.pixelated = enabled
	
func _on_fov_changed(new_value: float) -> void:
	options.fov = new_value
