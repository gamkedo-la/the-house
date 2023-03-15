extends StaticBody

const grimmor_text := "This old grimmor is open on a recipe or spell named [b]The Golden Handshake[/b]\n\n\"Mix one of each ingredients in a dark sauce of a cauldron:\nFIXME\""


var _is_reading_text := false
var _player_is_reading := false

func _ready():
	set_collision_layer_bit(CollisionLayers.player_interraction_raycast_layer_bit, true)
#	set_collision_mask_bit(CollisionLayers.player_interraction_raycast_layer_bit, true)
	

func player_interracts():
	start_reading_text()
		
func start_reading_text() -> void:
	assert(_player_is_reading)
	if _is_reading_text:
		return
	global.current_player.story_display.stop_display_sequence()
	global.current_player.examination_display.stop_display_sequence()
	global.current_player.action_display.stop_display_sequence()
	global.current_player.reading_display.display_text_sequence([grimmor_text])
	_is_reading_text = true

func stop_reading_text() -> void:
	global.current_player.reading_display.stop_display_sequence()
	_is_reading_text = false

func on_player_begin_pointing() -> void:
	_player_is_reading = true
		
func on_player_end_pointing() -> void:
	_player_is_reading = false
	if _is_reading_text:
		stop_reading_text()
