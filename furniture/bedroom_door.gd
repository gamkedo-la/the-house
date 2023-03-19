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
	global.current_player.examination_display.stop_display_sequence()
	unlock()
	
func player_interracts() -> void:
	global.current_player.action_display.display_text_sequence(["The ears are screwed in this door, I can't remove them.\nThey seem linked to a mechanism inside the door."])
	
func on_player_begin_pointing() -> void:
	if is_locked:
		global.current_player.examination_display.display_text_sequence(["These are real human ears.\nCut from several people's body. Then screwed in this door.\nBut why?"])
		
func on_player_end_pointing() -> void:
	if is_locked:
		global.current_player.examination_display.stop_display_sequence()
		
		
