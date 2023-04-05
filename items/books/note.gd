extends InteractiveItem

class_name PaperNote

export var note_key := ""
export var is_translated := false
export var translated_description := "This is an hand-written note. I managed to translate it."
export var translation_text := "This makes sense!\nThis note is now translated."

func _ready():
	mode = RigidBody.MODE_STATIC # Starts stuck to something.

func translate_note() -> void:
	is_translated = true
	description = translated_description
	global.current_player.action_display.display_text_sequence([translation_text], TextDisplay.DisplayMode.ADD_NEXT)

