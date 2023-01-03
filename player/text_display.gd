extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var _tween = $text_tween

var _texts_to_display := []
export(float, 0, 600) var text_display_duration_secs = 6.0
export(float, 0, 600) var fade_duration_secs = 5.0
const _alpha_property = "modulate:a"

func _ready():
	modulate.a = 0.0

var remove_me = 0

func _process(delta):
	if Input.is_action_just_pressed("item_activation"):
		remove_me += 1
		display_text("text number %d" % remove_me)


func display_text(new_text: String) -> void:
	assert(!new_text.empty())
	_texts_to_display.push_back(new_text)
	
	if not _tween.is_active():
		_start_display_texts()
	
func _start_display_texts() -> void:
	while _texts_to_display.size() > 0:
		bbcode_text = _texts_to_display.pop_front()

		# fade in
		print("new text fade in start now")
		_tween.interpolate_property(self, _alpha_property, 0.0, 1.0, fade_duration_secs, Tween.TRANS_CIRC, Tween.EASE_IN)	
		_tween.start()
		yield(_tween, "tween_all_completed")	# When the fade is done...
		print("new text fade in - done")
		
		# read
		yield(get_tree().create_timer(text_display_duration_secs), "timeout") # ...we wait some time for the player to read...
		
		# fade out
		print("new text fade out start now")
		_tween.interpolate_property(self, _alpha_property, 1.0, 0.0, fade_duration_secs, Tween.TRANS_CIRC, Tween.EASE_IN) # ... then we fade out
		_tween.start()
		print("modulate.a = ", modulate.a)
		yield(_tween, "tween_all_completed")	# and when it's done we chain with the next text, if any.
		print("new text fade out - done")
	
