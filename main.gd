extends Node

var current_scene_path : String

const credits_screen_path := "res://screens/credits/credits_screen.tscn"
const title_screen_path := "res://screens/title_screen.tscn"

const enable_background_loading := false

var _scene_loader : ResourceInteractiveLoader
var _loading_wait_frames : int = 1
var _loading_time_max := 100
var _loading_scene_to_get_back_to
var _loading_scene_path
	
func _ready():
	if OS.get_name() == "HTML5":
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(1920, 1080))
	
	if OS.has_feature("standalone"): # If we didnt run it from the editor
		OS.window_fullscreen = true # TODO: make this an option
		
	if enable_background_loading:
		set_process(false)
	
	if name == "main":
		to_title_screen()

func _process(time):
	if not enable_background_loading:
		return
		
	if _scene_loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if _loading_wait_frames > 0:
		_loading_wait_frames -= 1
		return

	var start = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < start + _loading_time_max:
		# Poll your loader.
		var err = _scene_loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var new_scene_resource = _scene_loader.get_resource()
			_scene_loader = null
			call_deferred("_end_loading", new_scene_resource)
			break
		elif err == OK:
			# TODO: update animation here if necessary
#			for 
			break 
		else: # Error during loading.
			print("ERROR during loading")
			_scene_loader = null
			break

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
	print("SCENE LOADING START : %s  (back scene: %s)" % [scene_path, screen_to_get_back_to])
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	_loading_wait_frames = 1
	_loading_scene_path = scene_path
	_loading_scene_to_get_back_to = screen_to_get_back_to
	
	if enable_background_loading:
		# Bootstrap background loading
		_scene_loader = ResourceLoader.load_interactive(scene_path)
		if _scene_loader == null:
			print("ERROR: failed to load scene : %s ", scene_path)
			return
		
		# TODO: start loading animation here
		
	else:
		_end_loading(load(scene_path))
	
	set_process(true)
	
	
func _end_loading(new_scene_resource) -> void:
	assert(new_scene_resource)
	print("SCENE LOADING ENDING...")
	_clear()
	print("SCENE LOADING: BEGIN INSTANTIATION")
	var new_scene = new_scene_resource.instance()
	print("SCENE LOADING: END INSTANTIATION")
	new_scene.master_scene = self
	if _loading_scene_to_get_back_to != "" :
		new_scene.scene_name_to_get_back_to = _loading_scene_to_get_back_to
	print("SCENE LOADING: adding scene as child")
	add_child(new_scene)
	print("SCENE LOADING: adding scene as child - DONE")
	current_scene_path = _loading_scene_path
	
	_loading_scene_to_get_back_to = null
	_loading_scene_path = null
	
	print("SCENE LOADING DONE: %s" % current_scene_path)
	
	
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
	
