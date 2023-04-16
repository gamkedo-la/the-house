extends Spatial


var is_on = false
onready var light_source := $"./light_source"
onready var audio_player := $"%audio_player"

onready var _sound_off : AudioStream = load("res://items/torchlight/off.wav")

func turn_on():
	is_on = true
	light_source.visible = true


func turn_off():
	is_on = false
	light_source.visible = false

	audio_player.stream = _sound_off
	audio_player.play()

func _on_lantern_use_item(_lantern):
	turn_off()


func _on_LightableArea_lit_using_fire():
	turn_on()
