extends PlayerState

# STATE:
# When the player is examining an hold item.
class_name State_Examining

var _exanimation_node : Spatial
var _mouse_rotations := Vector3.ZERO

const _rotation_speed := 3.0
const _mouse_rotation_speed := 8.0


func _init().("EXAMINING") -> void:
	pass

func enter():
	print("Examining now...")
	assert(player.is_holding_item())
	# TODO: add here moving the item in focus
	player.begin_item_examination()
	_exanimation_node = player.get_examination_node()

func leave():
	print("Stop examining...")
	assert(player.is_holding_item())
	player.end_item_examination()
	_exanimation_node = null

func update(delta):
	player.update_item_position(delta)
	
	if Input.is_action_just_pressed("item_examination"):
		state_machine.push_action(PlayerState.Action.stop_examining_item)
		return
	
	_update_examination_controls(delta)

func _update_examination_controls(delta):
	assert(_exanimation_node != null)
	
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
	
	_exanimation_node.rotate_x(rotations_to_apply.x)
	_exanimation_node.rotate_y(rotations_to_apply.y)
	_exanimation_node.rotate_z(rotations_to_apply.z)
	
	_mouse_rotations = Vector3.ZERO
	
func input_update(event: InputEvent):
	if event is InputEventMouseMotion:
		_mouse_rotations.x += event.relative.y
		_mouse_rotations.y += event.relative.x
		