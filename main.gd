extends Node


func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):	
	
	if Input.is_action_just_pressed("mouse_capture"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if Input.is_action_just_pressed("mouse_release"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

