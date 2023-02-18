extends Spatial

var _spawn_points := []
var _next_spawn_point = 0

func _ready() -> void :
	_add_spawn_points(self)

func _process(_delta):
	
	# for debug
	if Input.is_action_just_pressed("debug_spawn"):
		_player_jump_to_next_spawn_point()
		
		
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
		
