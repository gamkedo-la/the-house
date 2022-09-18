extends Node


func _input(event):
	if event is InputEventKey:
		if OS.get_name() != "HTML5" and event.scancode == KEY_ESCAPE:
			get_tree().quit()
			
