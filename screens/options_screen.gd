extends CanvasLayer

signal on_back_from_options()


func _ready():
	$back_button.connect("pressed", self, "_on_back_button_pressed")
	$game_button.connect("pressed", self, "_show_game_options")
	$graphics_button.connect("pressed", self, "_show_graphics_options")
	$audio_button.connect("pressed", self, "_show_audio_options")

	connect("visibility_changed", self, "_on_visibiilty_changed")

	set_process(false)

func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause_resume") or Input.is_action_just_pressed("mouse_release"):
		_on_back_button_pressed()

func _on_visibiilty_changed() -> void:
	if visible:
		$game_button.pressed = true
		_show_game_options()
	else:
		_hide_all_tabs()
	call_deferred("set_process", visible)

func _hide_all_tabs() -> void:
	for child in get_children():
		if child is CanvasLayer:
			child.visible = false

func _on_back_button_pressed():
	emit_signal("on_back_from_options")

func _show_game_options() -> void:
	_hide_all_tabs()
	$game_options_screen.visible = true

func _show_graphics_options() -> void:
	_hide_all_tabs()
	$graphic_options_screen.visible = true

func _show_audio_options() -> void:
	_hide_all_tabs()
	$audio_options_screen.visible = true

