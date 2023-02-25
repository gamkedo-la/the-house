extends Spatial

var master_scene = null # Dont use this except if this is a scene below main when the game is normally running


func _ready():
	$"%start_button".connect("pressed", self, "_start_new_game")


func _start_new_game():
	if master_scene:
		master_scene.start_new_game()
