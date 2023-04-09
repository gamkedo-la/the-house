tool
extends Sprite

enum Mode { Target, Take, Interract }

func _ready() -> void:
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	_center_in_screen()

func _on_screen_resized() -> void:
	_center_in_screen()

func _center_in_screen() -> void:
	var center = get_viewport_rect().size * 0.5
	position = center

func set_mode(mode: int) -> void:
	pass

