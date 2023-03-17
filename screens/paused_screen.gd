extends CanvasLayer

signal on_resume()

func _ready():
	$menu.visible = false # see https://github.com/godotengine/godot/issues/25384
	connect("visibility_changed", self, "_on_visibility_changed")
	
	$"%resume_button".connect("pressed", self, "_on_resume_button_pressed")
	$"%options_button".connect("pressed", self, "_on_options_button_pressed")
	$"%exit_button".connect("pressed", self, "_on_exit_button_pressed")
	$options_screen.connect("on_back_from_options", self, "_on_back_from_options")
	
func _on_visibility_changed() -> void:
	$menu.visible = visible

func _on_resume_button_pressed() -> void:
	$menu.visible = true
	emit_signal("on_resume")
	
func _on_options_button_pressed() -> void:
	$menu.visible = false
	$options_screen.visible = true
	
func _on_back_from_options() -> void:
	$menu.visible = true
	$options_screen.visible = false
	
func _on_exit_button_pressed() -> void:
	global.current_game.exit_game()
