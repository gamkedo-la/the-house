extends StaticBody

var _note_being_translated : PaperNote

var _is_displaying_text : bool = false

var _did_at_least_one_translation : bool = false

func _ready():
	 set_collision_layer_bit(CollisionLayers.player_interraction_raycast_layer_bit, true)
	
	
func player_interracts() -> void:
	if _is_displaying_text:
		return
	
	var item = global.current_player.get_item_in_hand()
	if item is PaperNote:
		if item.is_translated:
			global.current_player.action_display.display_text_sequence(["I already translated the code on this note."])
			
		else:
			global.current_player.info_display.stop_display_sequence()
			global.current_player.examination_display.stop_display_sequence()
			global.current_player.action_display.display_text_sequence(["Ok let's see ...", "...hmmm...", "...this should mean...that...", "..okay?..."])
			_note_being_translated = item
			global.current_player.action_display.connect("text_sequence_display_completed", self, "_on_translated_note")
	else:
		global.current_player.examination_display.display_text_sequence(["This looks like a Ouija board but far more complex and mechanical.\nI think it's used to [b]translate[/b] these unfamiliar [b]symbols[/b]?"])
		global.current_player.info_display.display_text_sequence(["[b]Interract[/b] with this while holding something with [b]symbols[/b] to attempt to [b]translate[/b] them."])
		
	_is_displaying_text = true
	
	
func on_player_begin_pointing() -> void:
	if _is_displaying_text:
		return
	var item = global.current_player.get_item_in_hand()
	if item is PaperNote:
		if item.is_translated:
			global.current_player.examination_display.display_text_sequence(["I managed to use this thing to translate the symbols on this note."])
		else:
			global.current_player.examination_display.display_text_sequence(["Could I [b]translate[/b] the symbols on this note with that thing?"])
	else:
		if _did_at_least_one_translation:
			global.current_player.examination_display.display_text_sequence(["I managed to use this thing to translate some [b]symbols[/b] on a note."])
		else:
			global.current_player.info_display.display_text_sequence(["Left Mouse Button -> [b]Interract[/b]."])
			global.current_player.examination_display.display_text_sequence(["What is this strange wooden contraption?"])
	
func on_player_end_pointing() -> void:
	global.current_player.examination_display.stop_display_sequence()
	global.current_player.info_display.stop_display_sequence()
	if _is_displaying_text:
		global.current_player.action_display.stop_display_sequence()
		if _note_being_translated is PaperNote:
			global.current_player.action_display.disconnect("text_sequence_display_completed", self, "_on_translated_note")
			_note_being_translated = null
			
		_is_displaying_text = false
	
func _on_translated_note() -> void:
	global.current_player.action_display.disconnect("text_sequence_display_completed", self, "_on_translated_note")
	if _note_being_translated is PaperNote:
		assert(not _note_being_translated.is_translated)
		_note_being_translated.translate_note()
		assert(_note_being_translated.is_translated)
		_note_being_translated = null
		_did_at_least_one_translation = true
