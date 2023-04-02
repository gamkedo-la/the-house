extends RichTextLabel

func _ready() -> void:
	if not global.is_dev_mode:
		set_process(false)
		visible = false

func _process(delta) -> void:
	set_text("FPS %s\nFrame time %s" % [Engine.get_frames_per_second(), delta])

