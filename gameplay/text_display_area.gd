extends Area
class_name TextDisplayArea

# Use this to specify a space where the player will get a text displayed.

export(Array, String) var bbtext_to_display := ["This will be read by [b]the player[/b] once they enter this area."]
export var display_only_once := true
export var stop_display_on_exit := false
export var prioritary_text := true
var _need_to_display = true
var _text_display_enabled = true

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
func _on_body_entered(player: Node) -> void:
	if _text_display_enabled and  _need_to_display and player is Player:
		player.display_text_sequence(bbtext_to_display, prioritary_text)
		_need_to_display = false

func _on_body_exited(player: Node) -> void:
	if player is Player:
		if stop_display_on_exit:
			print("stop_display_on_exit")
			player.stop_text_display()
		if not display_only_once:
			_need_to_display = true
		
func stop_text_display() -> void:
	_text_display_enabled = false
