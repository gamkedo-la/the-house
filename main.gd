extends Node

var current_scene_path : String

const credits_screen_path := "res://screens/credits/credits_screen.tscn"
const title_screen_path := "res://screens/title_screen.tscn"


	
func _ready():
	if OS.get_name() == "HTML5":
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(1920, 1080))
	
	if OS.has_feature("standalone"): # If we didnt run it from the editor
		OS.window_fullscreen = true # TODO: make this an option
	
	if name == "main":
		to_title_screen()
	

func _unhandled_key_input(event):
	if event.is_action_pressed("mute"):
		var muted = AudioServer.is_bus_mute(0)
		AudioServer.set_bus_mute(0, !muted)
		
	if event.is_action_pressed("mute_music"):
		var music_bus_id = AudioServer.get_bus_index("Music")
		var muted = AudioServer.is_bus_mute(music_bus_id)
		AudioServer.set_bus_mute(music_bus_id, !muted)
	
func _clear() -> void:
	utility.delete_children(self)

func change_current_scene(scene_path:String, screen_to_get_back_to: String = "") -> void:
	_clear()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var scene = load(scene_path).instance()
	scene.master_scene = self
	if screen_to_get_back_to != "" :
		scene.scene_name_to_get_back_to = screen_to_get_back_to
	add_child(scene)
	current_scene_path = scene_path
	
func start_new_game() -> void:
	change_current_scene("res://game/game.tscn")
	
func to_title_screen() -> void:
	change_current_scene(title_screen_path)
	
func to_credits_screen(screen_to_get_back_to: String = "") -> void:
	if screen_to_get_back_to == "" :
		screen_to_get_back_to = title_screen_path
	change_current_scene(credits_screen_path, screen_to_get_back_to)

	
func to_end_game_screen() -> void:
	change_current_scene("res://screens/end_game/end_game_screen.tscn")
	
