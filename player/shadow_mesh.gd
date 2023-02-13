extends MeshInstance

export var bob_size : float = 0.008
export var bob_freq : float = 10
export var bob_stop_speed : float = 0.5
export var breathing_bob_size : float = 0.01
export var breathing_bob_freq : float = 2.313

onready var _last_position := _current_position_on_plane()
onready var _last_start_moving_time := _now_in_secs()

onready var _camera : Camera = $"%Camera"
onready var _origin_height : float = self.transform.origin.y
onready var _origin_camera_height : float = _camera.transform.origin.y


func _current_position_on_plane() -> Vector2:
	var player : Spatial = get_parent()
	return Vector2(player.global_transform.origin.x, player.global_transform.origin.z)

func _now_in_secs() -> float:
	return Time.get_ticks_msec() * 0.001

func _current_height() -> float:
	var current_camera_height = _camera.transform.origin.y
	var camera_height_diff = _origin_camera_height - current_camera_height
	return _origin_height - camera_height_diff

func _physics_process(_delta) -> void:
	
	var time_since_beginning = _now_in_secs()
		
	# breathing constantly up and down
	var breathing_bobbing = sin(time_since_beginning * breathing_bob_freq) * breathing_bob_size

	# bob the child mesh up and down based on pos (fake footstep animation!)
	var new_pos = _current_position_on_plane()
	var distance_since_last_pos = (new_pos - _last_position).length()
	var is_moving = distance_since_last_pos > 0.0
		
	if not is_moving:
		_last_start_moving_time = time_since_beginning
		
	var secs_since_last_move_started = time_since_beginning - _last_start_moving_time
	var walking_bobbing := sin(secs_since_last_move_started * bob_freq) * bob_size
	
	
	# Gather both bobbings
	var height_modulation = breathing_bobbing + walking_bobbing
	_last_position = new_pos
	
	# apply height modulation
	transform.origin.y = _current_height() + height_modulation
	
