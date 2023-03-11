extends InteractiveItem

class_name MusicBox

export var is_playing_music := false setget _set_playing_music

func _ready():
	set_collision_layer_bit(CollisionLayers.audio_lock_collision_bit, true)
	connect("use_item", self, "_on_player_use")
	
	
func _set_playing_music(must_play:bool) -> void:
	if is_playing_music == must_play:
		return
		
	if must_play:
		play_music()
	else:
		stop_music()
	

func play_music() -> void:
	$music_player.play()
	is_playing_music = true
	
func stop_music() -> void:
	$music_player.stop()
	is_playing_music = false

func _on_player_use(this) -> void:
	_set_playing_music(not is_playing_music)
	

