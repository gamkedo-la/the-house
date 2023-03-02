extends Node

	
func _ready():
	if name == "main":
		to_title_screen()
	

func _unhandled_key_input(event):
	if event.is_action_pressed("mute"):
		var muted = AudioServer.is_bus_mute(0)
		AudioServer.set_bus_mute(0, !muted)
	
func _clear() -> void:
	utility.delete_children(self)

func _change_current_scene(scene_path:String) -> void:
	_clear()
	var scene = load(scene_path).instance()
	scene.master_scene = self
	add_child(scene)
	
func start_new_game() -> void:
	_change_current_scene("res://game/game.tscn")
	
func to_title_screen() -> void:
	_change_current_scene("res://screens/title_screen.tscn")
	

