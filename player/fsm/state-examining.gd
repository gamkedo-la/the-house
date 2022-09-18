extends PlayerState

# STATE:
# When the player is examining an hold item.
class_name State_Examining

var _examination_node : Spatial
var _mouse_rotations := Vector3.ZERO
var _mouse_zoom := 0.0
var _initial_zoom := 0

const _rotation_speed := 3.0
const _mouse_rotation_speed := 4.0
const _zoom_speed := 1.5
const _min_zoom_factor := 0.25
const _max_zoom_factor := 1.0

func _init().("EXAMINING") -> void:
	pass

func enter():
	print("Examining now...")
	assert(player.is_holding_item())
	# TODO: add here moving the item in focus
	player.begin_item_examination()
	_examination_node = player.get_examination_node()
	_initial_zoom = player.get_camera().fov

func leave():
	print("Stop examining...")
	assert(player.is_holding_item())
	player.end_item_examination()
#	player.get_item_in_hand.scale(1.0) # reset scale
	_examination_node = null
	player.get_camera().fov = _initial_zoom

func update(delta):
	
	if Input.is_action_just_pressed("item_examination"):
		state_machine.push_action(PlayerState.Action.stop_examining_item)
		return
	
	if Input.is_action_just_pressed("item_activation"):
		player.use_item()
	
	_update_examination_controls(delta)

func physics_update(delta: float) -> void:
	
	player.update_item_position(delta)

func _update_examination_controls(delta):
	assert(_examination_node != null)
	
	var rotations = Vector3.ZERO
	
	if Input.is_action_pressed("item_rotate_x_clockwise"):
		rotations.x = 1
	if Input.is_action_pressed("item_rotate_x_counter_clockwise"):
		rotations.x = -1
	if Input.is_action_pressed("item_rotate_y_clockwise"):
		rotations.y = 1
	if Input.is_action_pressed("item_rotate_y_counter_clockwise"):
		rotations.y = -1
	if Input.is_action_pressed("item_rotate_z_clockwise"):
		rotations.z = 1
	if Input.is_action_pressed("item_rotate_z_counter_clockwise"):
		rotations.z = -1
	
	var rotations_to_apply : Vector3 = rotations.normalized() * _rotation_speed * delta
	
	if Input.is_action_pressed("item_mouse_rotation_mode"):
		rotations_to_apply += _mouse_rotations.normalized() * _mouse_rotation_speed * delta
	
	_examination_node.rotate_x(rotations_to_apply.x)
	_examination_node.rotate_y(rotations_to_apply.y)
	_examination_node.rotate_z(rotations_to_apply.z)
	
	_mouse_rotations = Vector3.ZERO
	
	var zoom : float = _mouse_zoom
	if Input.is_action_pressed("item_zoom_in"):
		zoom += -_zoom_speed
	if Input.is_action_pressed("item_zoom_out"):
		zoom += _zoom_speed
	
	var camera = player.get_camera()
	var next_zoom = camera.fov + zoom
		
	if next_zoom >= _initial_zoom * _min_zoom_factor and next_zoom <= _initial_zoom * _max_zoom_factor:
		camera.fov = next_zoom
	
#	print("zoom = ", player.get_camera().fov)
	
	_mouse_zoom = 0.0
	
	
func input_update(event: InputEvent):
	if event is InputEventMouseMotion:
		_mouse_rotations.x += event.relative.y
		_mouse_rotations.y += event.relative.x
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			_mouse_zoom -= _zoom_speed
		if event.button_index == BUTTON_WHEEL_DOWN:
			_mouse_zoom += _zoom_speed
		
