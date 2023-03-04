extends CanvasLayer

signal on_back_from_options()


func _ready():
	$back_button.connect("pressed", self, "_on_back_button_pressed")

func _on_back_button_pressed():
	emit_signal("on_back_from_options")
