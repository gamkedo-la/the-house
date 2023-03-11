tool
extends Door

onready var _listening_area = $listening_area

var _audio_source
var _is_listening := true

func _ready():
	_listening_area.set_collision_mask_bit(CollisionLayers.audio_lock_collision_bit, true)
	_listening_area.connect("body_entered", self, "_on_audio_source_entered")
	_listening_area.connect("body_exited", self, "_on_audio_source_exited")
	
func _on_audio_source_entered(source) -> void:
	if source is MusicBox:
		print("music box is close to bedroom door")
		_audio_source = source

func _on_audio_source_exited(source) -> void:
	if source is MusicBox:
		_audio_source = null
		print("music box is far to bedroom door")

func _process(_delta):
	if _is_listening and _audio_source is MusicBox and _audio_source.is_playing_music:
		_unlock_the_door()

func _unlock_the_door():
	print("listening door unlocked")
	_is_listening = false
	_listening_area.set_deferred("monitoring", false)
	_listening_area.set_deferred("monitorable", false)
	
	unlock()
	
