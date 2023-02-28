extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var _tween = $text_tween

var _texts_to_display := []
export(float, 0, 600) var text_display_duration_secs = 5.0
export(float, 0, 600) var fade_duration_secs = 2.0
export(float, 0, 600) var quick_fade_duration_secs = 1.0
const _alpha_property := "modulate:a"
var _is_displaying_text := false
var _is_force_stopping := false
var _current_timer : SceneTreeTimer = null

func _init():
	modulate.a = 0.0

func _ready():
	pass

var remove_me = 0

# USE THIS TO DEBUG THE TEXT SYSTEM:
#func _process(delta):
#	if Input.is_action_just_pressed("item_activation"):
#		remove_me += 1
#		display_text("text number %d" % remove_me)
#
#	if _is_displaying_text:
#		print("modulate.a = ", modulate.a)


func display_text(new_text: String) -> void:
	assert(!new_text.empty())
	_texts_to_display.push_back(new_text)
	_start_display_texts()
	
static func centered_text(text: String) -> String:
	return "[center]%s[/center]" % text
	
func _start_display_texts() -> void:
	while _texts_to_display.size() > 0 and not _is_displaying_text and not _is_force_stopping:
		_is_displaying_text = true
		bbcode_text = centered_text(_texts_to_display.pop_front())
		print("---> ", bbcode_text)

		# fade in
		print("new text fade in start now ", modulate.a)
		_tween.interpolate_property(self, _alpha_property, modulate.a, 1.0, _fade_duration(), Tween.TRANS_QUAD, Tween.EASE_IN)	
		_tween.start()
		yield(_tween, "tween_all_completed")
		print("new text fade in - done ", modulate.a)
		
		if not _is_force_stopping:
			# read text
			print("not stopping so we display the text...")
			_current_timer = get_tree().create_timer(text_display_duration_secs)
			yield(_current_timer, "timeout") # ...we wait some time for the player to read...
		
		# fade out
		print("new text fade out start now ", modulate.a)
		_tween.interpolate_property(self, _alpha_property, modulate.a, 0.0, _fade_duration(), Tween.TRANS_QUAD, Tween.EASE_IN) 
		_tween.start()
		yield(_tween, "tween_all_completed")
		print("new text fade out - done ", modulate.a)
		_is_displaying_text = false
		
	if _texts_to_display.size() > 0 and not _is_displaying_text:
		_is_force_stopping = false
	
func stop_display() -> void:
	print("stop text display")
	if _is_displaying_text:
		print("stop text display -> canceling current")
		_is_force_stopping = true
		_texts_to_display.clear()
		if _current_timer is SceneTreeTimer:
			_current_timer.time_left = 0 # make sure we stop displaying the text right now
			print("stopping timer")
		

func _fade_duration() -> float:
	if _is_force_stopping:
		return quick_fade_duration_secs
	else:
		return fade_duration_secs
