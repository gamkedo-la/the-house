extends Spatial

class_name Game

var master_scene = null # Dont use this except if this is a scene below main when the game is normally running

var _spawn_points := []
var _next_spawn_point = 0

signal on_game_pause_or_resume()

func _ready() -> void :
	_add_spawn_points(self)
	
	$paused_screen.connect("on_resume", self, "_on_resume_requested")
	$"%event_end_reached".connect("body_entered", self, "_on_player_entered_end_area")

func _process(_delta):
	
	if Input.is_action_just_pressed("pause_resume"):
		toggle_pause()
	
	# for debug
	if Input.is_action_just_pressed("debug_spawn"):
		_player_jump_to_next_spawn_point()
		
	if Input.is_action_just_pressed("debug_light"):
		print("enable debug light!")
		_toggle_debug_light()
	
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
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$paused_screen.visible = false

	emit_signal("on_game_pause_or_resume", pause)

func _on_resume_requested():
	pause_game(false)
	
func exit_game():
	if master_scene:
		master_scene.to_title_screen()
	
func _on_player_entered_end_area(player : Node) -> void:
	if player is Player:
		master_scene.to_end_game_screen()
	
	
func _toggle_debug_light() -> void:
	var player = $"%player"
	var debug_light = player.get_node("Head/Camera/debug_spotlight")
	if debug_light.light_energy > 0.0:
		debug_light.light_energy = 0.0
	elif debug_light.light_energy == 0.0:
		debug_light.light_energy = 8.0
