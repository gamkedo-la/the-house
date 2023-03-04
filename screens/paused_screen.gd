extends CanvasLayer

signal on_resume()

func _ready():
	$resume_button.connect("pressed", self, "_on_resume_button_pressed")

func _on_resume_button_pressed() -> void:
	emit_signal("on_resume")
	
