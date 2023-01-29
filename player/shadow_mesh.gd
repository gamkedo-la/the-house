extends MeshInstance

export var bob_size : float = 0.1
export var bob_freq : float = 3.0
export var bob_stop_speed : float = 0.5
export var breathing_bob_size : float = 0.01
export var breathing_bob_freq : float = 2.313

onready var _last_position := _current_position_on_plane()
onready var _moving_distance : float = 0.0
onready var _origin_height : float = self.transform.origin.y

func _current_position_on_plane() -> Vector2:
	var player : Spatial = get_parent()
	return Vector2(player.global_transform.origin.x, player.global_transform.origin.z)

func _process(delta):
	
	var height_modulation = 0.0
		
	# breathing constantly up and down
	var time_since_beginning = Time.get_ticks_msec() * 0.001
	height_modulation += sin(time_since_beginning * breathing_bob_freq) * breathing_bob_size

	# bob the child mesh up and down based on pos (fake footstep animation!)
	var new_pos = _current_position_on_plane()
	var distance_since_last_pos = (new_pos - _last_position).length()

	if distance_since_last_pos == 0.0:
		_moving_distance = 0
	else:
		_moving_distance += distance_since_last_pos 
	_moving_distance = max(_moving_distance, 0.0)
	
	height_modulation += sin(_moving_distance * bob_freq) * bob_size
	_last_position = new_pos
	
	# apply height modulation
	transform.origin.y = _origin_height + height_modulation
	
