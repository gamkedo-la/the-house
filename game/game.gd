extends Spatial

class_name Game

var master_scene = null # Dont use this except if this is a scene below main when the game is normally running

var _spawn_points := []
var _next_spawn_point = 0

signal on_game_pause_or_resume()

func _ready() -> void :
	global.current_game = self
	
	if global.is_dev_mode:
		_add_spawn_points(self)
		$debug.visible = true
	
	$paused_screen.connect("on_resume", self, "_on_resume_requested")
#	$"%event_end_reached".connect("body_entered", self, "_on_player_entered_end_area")
	$"actual_game/toolshed/trap_door".connect("door_opened", self, "_end_game_reached")
	
	if OS.window_fullscreen:
		pause_game(false)
	
	OS.request_attention()

func _process(_delta):
		
	if not is_game_paused():
		if Input.is_action_just_pressed("pause_resume") or Input.is_action_just_pressed("mouse_release"):
			pause_game(true)
	
	# for debug
	if global.is_dev_mode:
		if Input.is_action_just_pressed("debug_spawn"):
			_player_jump_to_next_spawn_point()
			
		if Input.is_action_just_pressed("debug_light"):
			global.current_player._toggle_debug_light()
	
func _add_spawn_points(node:Node):
	if node is Spatial and node.name.count("spawn") > 0:
		_spawn_points.push_back(node)
	for child_node in node.get_children():
		_add_spawn_points(child_node) 

func _player_jump_to_next_spawn_point():
	var new_pos = _spawn_points[_next_spawn_point].global_transform.origin
	var player = $"%player"
	var initial_pos = player.global_transform.origin
	player.global_transform.origin = new_pos
	var item_in_hand = player.get_item_in_hand()
	if item_in_hand:
		item_in_hand.global_transform.origin = new_pos + (item_in_hand.global_transform.origin - initial_pos)
	
	_next_spawn_point += 1
	if _next_spawn_point >= _spawn_points.size():
		_next_spawn_point = 0
		

func toggle_pause():
	pause_game(!is_game_paused())

func is_game_paused():
	return get_tree().paused

func pause_game(pause: bool) -> void:
	get_tree().paused = pause
	print("game paused: ", pause)
	
	if pause:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$paused_screen.visible = true
		global.current_player.hide_all_texts()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$paused_screen.visible = false
		global.current_player.show_all_texts()

	emit_signal("on_game_pause_or_resume", pause)

func _on_resume_requested():
	pause_game(false)
	
func exit_game():
	if master_scene:
		global.current_game = null
		pause_game(false)
		master_scene.to_title_screen()
	
func _on_player_entered_end_area(player : Node) -> void:
	if player is Player:
		_end_game_reached()
			
func _end_game_reached() -> void:
	global.current_game = null
	pause_game(false)
	master_scene.to_end_game_screen()

