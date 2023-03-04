extends Node

var current_scene_path : String
	
func _ready():
	if OS.get_name() == "HTML5":
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(1920, 1080))
	
	if not OS.is_debug_build():
		OS.window_fullscreen = true # TODO: make this an option
	
	if name == "main":
		to_title_screen()
	

func _unhandled_key_input(event):
	if event.is_action_pressed("mute"):
		var muted = AudioServer.is_bus_mute(0)
		AudioServer.set_bus_mute(0, !muted)
	
func _clear() -> void:
	utility.delete_children(self)

func change_current_scene(scene_path:String, screen_to_get_back_to: String = "") -> void:
	_clear()
	var scene = load(scene_path).instance()
	scene.master_scene = self
	if screen_to_get_back_to != "" :
		scene.scene_name_to_get_back_to = screen_to_get_back_to
	add_child(scene)
	current_scene_path = scene_path
	
func start_new_game() -> void:
	change_current_scene("res://game/game.tscn")
	
func to_title_screen() -> void:
	change_current_scene("res://screens/title_screen.tscn")
	
func to_credits_screen(screen_to_get_back_to: String = "") -> void:
	if screen_to_get_back_to == "":
		screen_to_get_back_to = current_scene_path
	change_current_scene("res://screens/credits/credits_screen.tscn", screen_to_get_back_to)

