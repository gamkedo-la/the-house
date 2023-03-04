extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _current_tween : SceneTreeTween
var _texts_to_display := []
export(float, 0, 600) var text_display_duration_secs = 5.0
export(float, 0, 600) var fade_duration_secs = 1.0
const _alpha_property := "modulate:a"

enum Status { TEXT_HIDDEN, FADE_IN, TEXT_READABLE, FADE_OUT }
var _status = Status.TEXT_HIDDEN
var _status_start_time : float
var _fade_start_value : float
var _fade_target : float

func _init():
	modulate.a = 0.0

func display_text_sequence(new_text_sequence: Array, exclusive: bool = true) -> void:
	assert(!new_text_sequence.empty())
	for text in new_text_sequence:
		assert(text is String)
		
	if exclusive:
		_texts_to_display = new_text_sequence.duplicate()
	else:
		_texts_to_display.append_array(new_text_sequence.duplicate())
	
func stop_display_sequence() -> void:
	_texts_to_display = []
	if _status != Status.TEXT_HIDDEN or _status != Status.FADE_OUT:
		_start_next_status(Status.FADE_OUT)
	
static func centered_text(text: String) -> String:
	return "[center]%s[/center]" % text

static func now_secs() -> float:
	return Time.get_ticks_msec() * 0.001
	
func _process(_delta) -> void:
		
	if _status == Status.TEXT_HIDDEN:
		if _texts_to_display.empty():
			return
		_start_next_text()
		
	elif _status == Status.FADE_IN:
		_update_fade_in()
	elif _status == Status.TEXT_READABLE:
		_update_text_readable()
	elif _status == Status.FADE_OUT:
		_update_fade_out()
	
	
	
func _start_next_text() -> void:
	assert(not _texts_to_display.empty())
	assert(modulate.a == 0.0)
	var text = _texts_to_display.pop_front()
	bbcode_text = centered_text(text)
	_start_next_status(Status.FADE_IN)

func _start_next_status(next_status: int) -> void:
	_status_start_time = now_secs()
	_status = next_status
	_fade_start_value = modulate.a

func _update_fade_in() -> void:
	_fade_target = 1.0
	_fade_to(Status.TEXT_READABLE)
	
	
func _update_fade_out() -> void:
	_fade_target = 0.0
	_fade_to(Status.TEXT_HIDDEN)

func _fade_to(next_status : int) -> void:
	var secs_since_beginning = now_secs() - _status_start_time		
	
	var ratio_of_fade_time = secs_since_beginning / fade_duration_secs
	var new_alpha = smoothstep(_fade_start_value, _fade_target, ease(ratio_of_fade_time, 4.0))
	
	modulate.a = new_alpha
	
	if modulate.a == _fade_target:
		_start_next_status(next_status)

func _update_text_readable() -> void:
	if text_display_duration_secs == 0:
		return
		
	var secs_since_beginning = now_secs() - _status_start_time
	if secs_since_beginning >= text_display_duration_secs:
		_start_next_status(Status.FADE_OUT)

