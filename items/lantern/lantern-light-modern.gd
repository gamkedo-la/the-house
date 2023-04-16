extends Spatial


var is_on = false
onready var light_source : OmniLight = $"./light"

onready var audio_player := $"%audio_player"

onready var _sound_on : AudioStream = load("res://items/torchlight/on.wav")
onready var _sound_off : AudioStream = load("res://items/torchlight/off.wav")

var _is_ready := false

func toggle_light():
	if is_on:
		turn_off()
	else:
		turn_on()

func turn_on():
	is_on = true
	light_source.visible = true

	audio_player.stream = _sound_on
	audio_player.play()

func turn_off():
	is_on = false
	light_source.visible = false

	audio_player.stream = _sound_off
	audio_player.play()

func _on_lantern_use_item(_lantern):
	toggle_light()
