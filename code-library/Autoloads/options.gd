extends Node

var toggle_crouch := true
var toggle_run := false
var toggle_hold := false

var mouse_camera_speed := 1.0

onready var fullscreen := false setget _set_fullscreen
onready var vsync := true setget _set_vsync
var fov := 70.0

var pixelated := false

const audio_volume_min := -60.0
const audio_volume_max := 6.0
const audio_gain_fx_idx := 0

var audio_mute_master := false setget _set_mute_master
var audio_mute_music := false setget _set_mute_music

var audio_volume_master := 1.0 		setget _set_volume_master
var audio_volume_music := 1.0		setget _set_volume_music
var audio_volume_sounds := 1.0		setget _set_volume_sounds
var audio_volume_ambiance := 1.0	setget _set_volume_ambiance


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

func _set_volume_master(value: float) -> void:
	audio_volume_master = value
	_set_volume_for("Master", value)
	
func _set_volume_music(value: float) -> void:
	audio_volume_music = value
	_set_volume_for("Music", value)
	
func _set_volume_sounds(value: float) -> void:
	audio_volume_sounds = value
	_set_volume_for("Sounds", value)
	
func _set_volume_ambiance(value: float) -> void:
	audio_volume_ambiance = value
	_set_volume_for("Ambiant", value)
	

func _set_volume_for(bus_name : String, value: float) -> void:
	var idx = AudioServer.get_bus_index(bus_name)
	var gain : AudioEffectAmplify = AudioServer.get_bus_effect(idx, audio_gain_fx_idx)
	var gain_db := 0.0
	if value < 1.0:
		gain_db = lerp(audio_volume_min, 0.0, value)
	elif value > 1.0:
		gain_db = lerp(0.0, audio_volume_max, value - 1.0)
	gain.volume_db = gain_db

func _set_mute_master(enabled: bool) -> void:
	audio_mute_master = enabled
	_set_mute_channel("Master", enabled)
	
func _set_mute_music(enabled: bool) -> void:
	audio_mute_music = enabled
	_set_mute_channel("Music", enabled)
	
func _set_mute_channel(bus_name: String, enabled: bool) -> void:
	var idx = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(idx, enabled)
