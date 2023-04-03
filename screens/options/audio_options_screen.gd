extends CanvasLayer

onready var _toggle_mute := $"%toggle_mute"
onready var _toggle_mute_music := $"%toggle_mute_music"
onready var _slider_master := $"%slider_master"
onready var _slider_music := $"%slider_music"
onready var _slider_sounds := $"%slider_sounds"
onready var _slider_ambiance := $"%slider_ambiance"

func _ready() -> void:
	
	if OS.get_name() == "HTML5":
		_toggle_mute.disabled = true
	_toggle_mute.pressed = options.audio_mute_master
	_toggle_mute.connect("toggled", self, "_on_mute_master_changed")
	
	_toggle_mute_music.pressed = options.audio_mute_music
	_toggle_mute_music.connect("toggled", self, "_on_mute_music_changed")
	
	_slider_master.value = options.audio_volume_master
	_slider_master.connect("value_changed", self, "_on_volume_master_changed")
	
	_slider_music.value = options.audio_volume_music
	_slider_music.connect("value_changed", self, "_on_volume_music_changed")
	
	_slider_sounds.value = options.audio_volume_sounds
	_slider_sounds.connect("value_changed", self, "_on_volume_sounds_changed")
	
	_slider_ambiance.value = options.audio_volume_ambiance
	_slider_ambiance.connect("value_changed", self, "_on_volume_ambiance_changed")
	
	
func _on_mute_master_changed(enabled: bool) -> void:
	options.audio_mute_master = enabled
	
func _on_mute_music_changed(enabled: bool) -> void:
	options.audio_mute_music = enabled
		
func _on_volume_master_changed(new_value: float) -> void:
	options.audio_volume_master = new_value

func _on_volume_music_changed(new_value: float) -> void:
	options.audio_volume_music = new_value
	
func _on_volume_sounds_changed(new_value: float) -> void:
	options.audio_volume_sounds = new_value

func _on_volume_ambiance_changed(new_value: float) -> void:
	options.audio_volume_ambiance = new_value
	
