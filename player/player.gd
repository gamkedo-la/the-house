extends KinematicBody

class_name Player

export var walk_speed : float = 400.0
export var climb_speed : float = 200.0
export var view_speed : float = 0.002
export var gravity_factor : float= 100.0

const limit_up_angle : float = deg2rad(75.0)
const limit_down_angle : float = deg2rad(-89.0)

var _gravity := Vector3(0.0, -ProjectSettings.get_setting("physics/3d/default_gravity"), 0.0)

onready var _camera : Camera = $"%Camera"
onready var _interraction_ray: RayCast = $"%InterractionRay"
onready var _hand_node : Spatial = $"%Camera/right_hand"
onready var _drop_spot : Spatial = $"%Camera/drop_spot"
onready var _examination_spot : Spatial = $"%Camera/examination_spot"
onready var _center_holding_spot : Spatial = $"%Camera/center_holding_spot"
onready var _pixelator := $"%Camera/screen pixelation"
onready var _state_machine : PlayerStateMachine = $"PlayerStateMachine"
onready var _feet_audio : AudioStreamPlayer3D = $"Body/feet_audio_player"
var _pointed_item : InteractiveItem
var _held_item: InteractiveItem

var _last_linear_velocity: Vector3

onready var _crouch_tween := $"%Camera/crouch_tween"
onready var _up_position : Vector3 = _camera.transform.origin
onready var _crouched_position: Vector3 = _up_position + Vector3(0, -0.5, 0)
var _is_crouched := false
var _crouch_duration := 0.33

var _is_holding_front := false

onready var _initial_examination_transform : Transform = _examination_spot.transform

enum MovementMode { Walking, Climbing }
var _movement_mode : int = MovementMode.Walking

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):	
	
	if Input.is_action_just_pressed("mouse_capture"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if Input.is_action_just_pressed("mouse_release"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready():
	set_collision_layer_bit(ItemUtils.climbing_area_collision_bit, true)
	_state_machine.start_with_player(self)

func _process(delta):
	# TEMPORARY:
	if Input.is_action_just_pressed("debug_switch_pixelator"):
		if _pixelator.visible:
			_pixelator.hide()
		else:
			_pixelator.show()
	# END OF TEMPORARY

# Common updates for when the player can explore freely
func exploration_update(delta: float):
	update_walk(delta)
	update_item_position(delta)
	update_interraction_ray()

# TODO: make an option to decide if the crouch action is a toggle or an input hold
#	if Input.is_action_just_pressed("toggle_crouch"):
#		toggle_crouch()
	# Currently: hold to crouch
	if Input.is_action_pressed("toggle_crouch"):
		crouch();
	else:
		get_up()

# Common input event handling for when the player can explore freely
func exploration_input_handling(event: InputEvent):
	update_orientation(event)

func set_movement_mode(new_mode: int) -> void:
	_movement_mode = new_mode

func get_movement_mode() -> int:
	return _movement_mode

# Call this only once per _physics_update()
func update_walk(delta) -> void:
	var translation = Vector3()

	if Input.is_action_pressed("move_left"):
		translation += Vector3.LEFT

	if Input.is_action_pressed("move_right"):
		translation += Vector3.RIGHT

	if _movement_mode == MovementMode.Walking:
		if Input.is_action_pressed("move_forward"):
			translation +=  Vector3.FORWARD

		if Input.is_action_pressed("move_backward"):
			translation += Vector3.BACK
			
	elif _movement_mode == MovementMode.Climbing:
		if _camera.global_rotation.x >= deg2rad(45.0): # Looking up
			if Input.is_action_pressed("move_forward"):
				translation +=  Vector3.UP

			if Input.is_action_pressed("move_backward"):
				translation += Vector3.DOWN
				
		elif _camera.global_rotation.x <= deg2rad(-45.0): # Looking down
			if Input.is_action_pressed("move_forward"):
				translation +=  Vector3.DOWN

			if Input.is_action_pressed("move_backward"):
				translation += Vector3.UP
				
		else: # Looking more or less horizontally
			if Input.is_action_pressed("move_forward"):
				translation +=  Vector3.FORWARD

			if Input.is_action_pressed("move_backward"):
				translation += Vector3.BACK
			
	else:
		assert(false, "unhandleded movement mode") 

	var speed = current_move_speed()
	if _movement_mode == MovementMode.Climbing:
		speed = climb_speed
	
	var movement_translation = translation.normalized() * speed * delta
	# Make sure we move towards the direction currently faced, on the "ground plane" (not the camera direction)
	var oriented_movement =  global_transform.basis.get_rotation_quat() * movement_translation
	
	# Apply gravity if we are walking on the ground, otherwise we are holding on a ladder or climbing
	if _movement_mode == MovementMode.Walking:
		var gravity = _gravity * delta * gravity_factor
		oriented_movement += gravity

	_last_linear_velocity = move_and_slide(oriented_movement, Vector3.UP, true)
	
	if movement_translation.length() > 0.0:
		_feet_audio.begin_walk(FootAudio.StepSurface.House)
	else:
		_feet_audio.end_walk()
		
	

func current_move_speed() -> float:
	if _is_crouched:
		return crouch_speed()
	else:
		return walk_speed

func crouch_speed() -> float:
	return walk_speed / 2

# Call this only once per _input() or _unhandled_input()
func update_orientation(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
		
	if(event is InputEventMouseMotion ):
		rotate_y(-event.relative.x * view_speed)
		
		# Here we want to avoid the camera to go up until being in our back
		# or go down until being in our back.
		# To avoid this we limit the angles possible when looking up and down.
		var rotation_x_to_apply = -event.relative.y * view_speed
		var attempted_next_rotation := _camera.global_rotation + Vector3(rotation_x_to_apply, 0.0, 0.0)
		var next_x_rotation := min(limit_up_angle, max(limit_down_angle, attempted_next_rotation.x))
		var next_rotation = Vector3(next_x_rotation, attempted_next_rotation.y, attempted_next_rotation.z)
		_camera.global_rotation = next_rotation

func update_item_position(delta: float) -> void:
	# this function assumes the player position and orientation have been updated already
	if not _held_item:
		return
	_held_item.update_movement(delta, _last_linear_velocity)

func update_interraction_ray() -> void:
	if _interraction_ray.is_colliding():
		var something = _interraction_ray.get_collider()
		if something is InteractiveItem and something.is_takable_now() and (_pointed_item == null or _pointed_item != something):
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
	
func is_pointing_takable_item() -> bool:
	return _pointed_item is InteractiveItem && _pointed_item.is_takable_now()

func get_item_in_hand() -> InteractiveItem:
	return _held_item
	
func is_holding_item() -> bool:
	return get_item_in_hand() != null
	
func take_item(item_node: InteractiveItem) -> void:
	assert(item_node)
	print("PLAYER: take item %s" % item_node)
	item_node.take(_hand_node)
	_held_item = item_node
	_held_item.connect("snapping_into_position", self, "_on_item_snapping_into_posiiton")
	assert(is_holding_item())

func drop_item() -> void:
	var item = get_item_in_hand()
	assert(item is InteractiveItem)
	print("PLAYER: drop item %s" % item)
	_held_item.disconnect("snapping_into_position", self, "_on_item_snapping_into_posiiton")
	_held_item = null
	var drop_spot : Node = item # Drop where the item is now
	item.drop(drop_spot)
	assert(not is_holding_item())
	
func _on_item_snapping_into_posiiton():
	# Probably the item is a key going into a lock.
	# We just release our hold.
	_state_machine.push_action(PlayerState.Action.drop_item)
	
func use_item() -> void:
	var held_item = get_item_in_hand()
	if held_item != null:
		held_item.activate()

func _resume_holding_item() -> void:
	var held_item = get_item_in_hand()
	assert(held_item is InteractiveItem)
	held_item.track(_hand_node)

		
func begin_item_examination():
	var held_item = get_item_in_hand()
	assert(held_item is InteractiveItem)
	_examination_spot.transform = _initial_examination_transform
	held_item.track(_examination_spot)
	
func end_item_examination():
	_resume_holding_item()

func get_examination_node() -> Spatial:
	return _examination_spot
	
func get_examination_axis() -> Vector3:
	return (_examination_spot.transform.origin - _camera.transform.origin).normalized()
	
func begin_center_item_holding() -> void:
	_is_holding_front = true
	var held_item = get_item_in_hand()
	assert(held_item is InteractiveItem)
	held_item.track(_center_holding_spot, held_item.follow_orientation_when_held_front)

func end_center_item_holding() -> void:
	_is_holding_front = false
	_resume_holding_item()

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

func get_camera() -> Camera:
	return _camera

