tool
extends Sprite

class_name CenterSymbol

enum Symbol { Target, Take, Interract }

func _ready() -> void:
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	_center_in_screen()

func _on_screen_resized() -> void:
	_center_in_screen()

func _center_in_screen() -> void:
	var center = get_viewport_rect().size * 0.5
	position = center

# See Symbol
func set_symbol(symbol: int) -> void:
	frame = symbol

func reset_symbol() -> void:
	set_symbol(Symbol.Target)
