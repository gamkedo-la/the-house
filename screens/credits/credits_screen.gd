extends Node2D

var master_scene = null
var scene_name_to_get_back_to : String = "title_screen"

const text_file_path := "res://screens/credits/credits_text.txt" # BEWARE: THIS FILE/PATH MUST BE MANUALLY SET AS BEING EXPORTED IN EACH EXPORT CONFIGURATION

func _ready():
	var file = File.new()
	file.open(text_file_path, File.READ)
	var credits_text = file.get_as_text()
	file.close()

	$"%credits_text".bbcode_text = credits_text
	$"%back_button".connect("pressed", self, "_on_back_pressed")


func _on_back_pressed():
	if master_scene:
		master_scene.change_current_scene(scene_name_to_get_back_to)
