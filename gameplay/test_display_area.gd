extends Area
class_name TextDisplayArea

# Use this to specify a space where the player will get a text displayed.

export(Array, String) var bbtext_to_display := ["This will be read by [b]the player[/b] once they enter this area."]
export var display_only_once := false setget _set_display_only_once
export var stop_display_on_exit := true
export var prioritary_text := true
var _need_to_display = true

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
func _on_body_entered(player: Node) -> void:
	if _need_to_display and player is Player:
		if prioritary_text:
			print("stop_display_on_exit - prioritary")
			player.stop_text_display()
		for bbtext in bbtext_to_display:
			player.display_text(bbtext)
		if display_only_once:
			_need_to_display = false

func _on_body_exited(player: Node) -> void:
	if stop_display_on_exit and player is Player:
		print("stop_display_on_exit")
		player.stop_text_display()
		
func _set_display_only_once(toggle : bool) -> void:
	display_only_once = toggle
	if display_only_once == false:
		stop_display_on_exit = true
		prioritary_text = true
		
