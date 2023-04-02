extends CanvasLayer

signal on_resume()

func _ready():
	$menu.visible = false # see https://github.com/godotengine/godot/issues/25384
	connect("visibility_changed", self, "_on_visibility_changed")
	
	$"%resume_button".connect("pressed", self, "_on_resume_button_pressed")
	$"%options_button".connect("pressed", self, "_on_options_button_pressed")
	$"%exit_button".connect("pressed", self, "_on_exit_button_pressed")
	$options_screen.connect("on_back_from_options", self, "_on_back_from_options")
	
	set_process(false)
	
func _process(_delta) -> void:
	if not $options_screen.visible:
		if Input.is_action_just_pressed("pause_resume") or Input.is_action_just_pressed("mouse_release"):
			_resume()
	
func _on_visibility_changed() -> void:
	$menu.visible = visible
	$options_screen.visible = false
	call_deferred("set_process", visible)

func _on_resume_button_pressed() -> void:
	_resume()
	
func _on_options_button_pressed() -> void:
	$menu.visible = false
	$options_screen.visible = true
	
func _on_back_from_options() -> void:
	$menu.visible = true
	$options_screen.visible = false
	
func _on_exit_button_pressed() -> void:
	global.current_game.exit_game()

func _resume() -> void:
	$menu.visible = true
	$options_screen.visible = false
	emit_signal("on_resume")
	
