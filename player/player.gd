extends KinematicBody

class_name Player

const walk_speed := 500.0
const view_speed := 0.002 # TODO: make this a game setting

var _gravity := Vector3(0.0, -ProjectSettings.get_setting("physics/3d/default_gravity"), 0.0)

onready var _camera := $"%Camera"
onready var _interraction_ray: RayCast = $"%InterractionRay"
onready var _hand_node := $"%Camera/right_hand"
onready var _drop_spot := $"%Camera/drop_spot"
onready var _pixelator := $"%Camera/screen pixelation"
onready var _state_machine : PlayerStateMachine = $"PlayerStateMachine"
var _pointed_item : InteractiveItem
var _held_item: InteractiveItem

var _last_linear_velocity: Vector3

onready var _crouch_tween := $"%Camera/crouch_tween"
onready var _up_position : Vector3 = _camera.transform.origin
onready var _crouched_position: Vector3 = _up_position + Vector3(0, -0.5, 0)
var _is_crouched := false
var _crouch_duration := 0.33

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # TODO: have a way to switch that on/off
	
func _ready():
	_state_machine.start_with_player(self)

func _process(delta):
	# TEMPORARY:
	if Input.is_action_just_pressed("debug_switch_pixelator"):
		if _pixelator.visible:
			_pixelator.hide()
		else:
			_pixelator.show()
	# END OF TEMPORARY
		
			
# Call this only once per _physics_update()
func update_walk(delta) -> void:
	var translation = Vector3()

	if Input.is_action_pressed("move_left"):
		translation += Vector3.LEFT

	if Input.is_action_pressed("move_right"):
		translation += Vector3.RIGHT

	if Input.is_action_pressed("move_forward"):
		translation += Vector3.FORWARD

	if Input.is_action_pressed("move_backward"):
		translation += Vector3.BACK

	var movement_translation = translation.normalized() * walk_speed * delta
	# Make sure we move towards the direction currently faced, on the "ground plane" (not the camera direction)
	var oriented_movement =  global_transform.basis.get_rotation_quat() * movement_translation

	_last_linear_velocity = move_and_slide(oriented_movement + _gravity, Vector3.UP, true)
	
	_update_item_position(delta)

# Call this only once per _input() or _unhandled_input()
func update_orientation(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		rotate_y(-event.relative.x * view_speed)
		_camera.rotate_x(-event.relative.y * view_speed)

func _update_item_position(delta: float) -> void:
	# this function assumes the player position and orientation have been updated already
	if not _held_item:
		return
	_held_item.update_movement(delta, _last_linear_velocity)
	


func update_interraction_ray() -> void:
	if _interraction_ray.is_colliding():
		var something = _interraction_ray.get_collider()
		if something is InteractiveItem and (_pointed_item == null or _pointed_item != something):
			if _pointed_item != null:
				_pointed_item.hilite(false)
			_pointed_item = something
			_pointed_item.hilite(true)
			print("Highlight ON: %s" % _pointed_item)
	else:
		if _pointed_item is InteractiveItem:
			print("Highlight OFF: %s" % _pointed_item)
			_pointed_item.hilite(false)
			_pointed_item = null
	

func get_currently_pointed_item() -> InteractiveItem:
	return _pointed_item

func is_pointing_item() -> bool:
	return _pointed_item is InteractiveItem

func get_item_in_hand() -> InteractiveItem:
	return _held_item
#	for maybe_item in _hand_node.get_children():
#		if maybe_item is InteractiveItem:
#			return maybe_item
#	return null
	
func is_holding_item() -> bool:
	return get_item_in_hand() != null
	
func take_item(item_node: InteractiveItem) -> void:
	assert(item_node)
	print("PLAYER: take item %s" % item_node)
#	item_node.get_parent().remove_child(item_node)
#	_hand_node.add_child(item_node)
	item_node.take(_hand_node)
	_held_item = item_node
	
func drop_item() -> void:
	var item = get_item_in_hand()
	assert(item is InteractiveItem)
	print("PLAYER: drop item %s" % item)
#	_hand_node.remove_child(item)
#	get_parent().add_child(item)
	item.drop(_drop_spot)
	
func use_item() -> void:
	var held_item = get_item_in_hand()
	if held_item != null:
		held_item.activate()

func crouch() -> void:
	if _is_crouched:
		return
	
	var result = _crouch_tween.interpolate_property(_camera, "translation", _camera.transform.origin, _crouched_position, _crouch_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	assert(result == true)
	result = _crouch_tween.start()
	assert(result == true)
	
	_is_crouched = true
	
	
func get_up() -> void:
	if not _is_crouched:
		return
		
	var result = _crouch_tween.interpolate_property(_camera, "translation", _camera.transform.origin, _up_position, _crouch_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	assert(result == true)
	result = _crouch_tween.start()
	assert(result == true)
	
	_is_crouched = false
	
func is_crouched() -> bool:
	return _is_crouched
	
func toggle_crouch() -> void:
	print("Toggle Crouching")
	if _is_crouched:
		get_up()
	else:
		crouch()
