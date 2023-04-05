extends Node2D

var master_scene = null
var scene_name_to_get_back_to : String = "title_screen"

func _ready():
	$"%back_button".connect("pressed", self, "_on_back_pressed")


func _on_back_pressed():
	if master_scene:
		master_scene.to_credits_screen()

