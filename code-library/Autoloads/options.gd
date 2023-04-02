extends Node

var toggle_crouch := true
var toggle_run := false
var toggle_hold := false

var mouse_camera_speed := 1.0

onready var fullscreen := false setget _set_fullscreen
onready var vsync := true setget _set_vsync
var fov := 70.0

var pixelated := false

# TODO: persist these options and apply what's necessary in _ready()
func _ready() -> void:
	if OS.get_name() == "HTML5":
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(1920, 1080))
	
	if OS.has_feature("standalone"): # If we didnt run it from the editor
		_set_fullscreen(true)
		
	
func _set_fullscreen(value: bool) -> void:
	if OS.get_name() != "HTML5":
		fullscreen = value
		OS.window_fullscreen = value

func _set_vsync(value: bool) -> void:
	vsync = value
	OS.vsync_enabled = value
