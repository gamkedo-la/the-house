extends StaticBody

export var attic_trapdoor_path : NodePath
var _attic_trapdoor : Door

var _is_displaying_info := false

func _ready():
	set_collision_layer_bit(CollisionLayers.player_interraction_raycast_layer_bit, true)
	assert(attic_trapdoor_path)
	_attic_trapdoor = get_node(attic_trapdoor_path)

func player_interracts() -> void:
	if _attic_trapdoor.is_locked:
		var item = global.current_player.get_item_in_hand()
		if item is PaperNote and item.is_translated:
			if item.note_key == "attic":
				_attic_trapdoor.unlock()
			else:
				global.current_player.action_display.display_text_sequence(["This code does not seem to make this keypad react..."])
		else:
			global.current_player.action_display.display_text_sequence(["I will need a [b]code[/b] to make this keypad work."])
			if not _is_displaying_info:
				global.current_player.info_display.display_text_sequence(["[b]Hold[/b] an item with the code while [b]interracting[/b] with this keypad to try that code."])
				_is_displaying_info = true
	else:
		global.current_player.action_display.display_text_sequence(["This keypad opened the access to the attic, it's unlocked."])

func on_player_end_pointing() -> void:
	if _is_displaying_info:
		global.current_player.info_display.stop_display_sequence()
		_is_displaying_info = false
