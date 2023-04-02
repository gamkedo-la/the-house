extends CanvasLayer

signal on_back_from_options()


func _ready():
	$back_button.connect("pressed", self, "_on_back_button_pressed")
	$game_button.connect("pressed", self, "_show_game_options")
	$graphics_button.connect("pressed", self, "_show_graphics_options")
	$audio_button.connect("pressed", self, "_show_audio_options")
	$controls_button.connect("pressed", self, "_show_controls_options")
	
	connect("visibility_changed", self, "_on_visibiilty_changed")

func _on_visibiilty_changed() -> void:
	if visible:
		_show_game_options()
	else:
		_hide_all_tabs()

func _hide_all_tabs() -> void:
	$audio_options_screen.visible = false
	$game_options_screen.visible = false
	$graphic_options_screen.visible = false
	$controls_options_screen.visible = false

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
	
func _show_controls_options() -> void:
	_hide_all_tabs()
	$controls_options_screen.visible = true
