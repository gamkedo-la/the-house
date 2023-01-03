extends Area
class_name TextDisplayArea

# Use this to specify a space where the player will get a text displayed.

export(Array, String) var bbtext_to_display := ["This will be read by [b]the player[/b] once they enter this area."]
export var display_only_once := false
var _need_to_display = true

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(player: Node):
	if _need_to_display and player is Player:
		for bbtext in bbtext_to_display:
			player.display_text(bbtext)
		if display_only_once:
			_need_to_display = false
