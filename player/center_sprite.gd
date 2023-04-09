tool
extends Sprite

class_name CenterSymbol

enum Symbol { Target, Take, Interract, Crouch, Ladder, Mushroom }
export(Symbol) var symbol := Symbol.Target setget set_symbol

export var lock_on_center := false

func _ready() -> void:
	if lock_on_center:
		get_tree().connect("screen_resized", self, "_on_screen_resized")
		_center_in_screen()

func _on_screen_resized() -> void:
	_center_in_screen()

func _center_in_screen() -> void:
	var center = get_viewport_rect().size * 0.5
	position = center

# See Symbol
func set_symbol(new_symbol: int) -> void:
	assert(Symbol.values().has(new_symbol))
	symbol = new_symbol
	frame = symbol

func reset_symbol() -> void:
	set_symbol(Symbol.Target)
