extends KinematicBody

class_name Player

export var walking_speed : float = 2.0
export var running_speed : float = 4.0
export var crouching_speed : float = 1.0
export var climbing_speed : float = 1.0
export var view_speed : float = 0.002
export var gravity_factor : float= 1.0
export var interraction_distance : float = 1.2
export var auto_pointing_distance : float = 4.0
export var floor_max_angle : float = 45.0
export var fall_check_max_depth_allowed : float = 6.0
export var fall_check_distance : float = 1.5

const limit_up_angle : float = deg2rad(75.0)
const limit_down_angle : float = deg2rad(-75.0)


onready var _camera : Camera = $"%Camera"
onready var _head : Spatial = $"Head"
onready var _body : CollisionShape = $"%body"
onready var _body_crouched : CollisionShape = $"%body_crouched"
onready var _feet_for_interior : CollisionShape = $"%feet_for_interior"
onready var _head_spot_crouched : Spatial = $"%head_spot_crouched"
onready var _interraction_ray: RayCast = $"%InterractionRay"
onready var _ground_checker: RayCast = $"%ground_checker"
onready var _slope_checker: RayCast = $"%slope_checker"
onready var _fall_checker: RayCast = $"%fall_checker"
onready var _hand_node : Spatial = $"%Camera/right_hand"
onready var _examination_spot : Spatial = $"%Camera/examination_spot"
onready var _center_holding_spot : Spatial = $"%Camera/center_holding_spot"
onready var _state_machine : PlayerStateMachine = $"PlayerStateMachine"
onready var _feet_audio : AudioStreamPlayer3D = $"%feet_audio_player"
onready var _debug_status : RichTextLabel = $"%debug_status"
onready var _debug_light : OmniLight = $"%debug_light"

onready var story_display : TextDisplay = $"%text_display"
onready var action_display : TextDisplay = $"%action_display"
onready var info_display : TextDisplay = $"%info_display"
onready var examination_display : TextDisplay = $"%examination_display"


var _pointed_item : InteractiveItem
var _pointed_usable_entity : Spatial
var _held_item: InteractiveItem
var _initial_hand_transform : Transform
var _initial_head_transform : Transform

var _last_linear_velocity: Vector3

var did_light_a_candle := false
var did_unlock_using_a_key := false
var did_try_to_open_door := false

onready var _crouch_tween := $"%Camera/crouch_tween"
onready var _up_position : Vector3 = _camera.transform.origin
var _is_crouched := false
var _is_crouch_locked := false
var did_crouch_changed_this_frame := false
var _crouch_duration := 0.33
var _is_running := false

var _is_holding_front := false
var _is_examining := false

onready var _initial_examination_transform : Transform = _examination_spot.transform

enum MovementMode { Walking, Climbing }
var _movement_mode : int = MovementMode.Walking

func _input(event) -> void:
	
	if Input.is_action_just_pressed("mouse_capture"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if Input.is_action_just_pressed("mouse_release"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready() -> void:
	global.current_player = self
	set_collision_layer_bit(CollisionLayers.climbing_area_collision_bit, true)
	_state_machine.start_with_player(self)
	_initial_hand_transform = _hand_node.transform
	_initial_head_transform = _head.transform
	
	_body_crouched.visible = false
	_body_crouched.disabled = true
	_body.visible = true
	_body.disabled = false
	_feet_for_interior.visible = false
	_feet_for_interior.disabled = true
	
	yield(get_tree().create_timer(1.0), "timeout")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

# Common updates for when the player can explore freely
func exploration_update(delta: float):
	did_crouch_changed_this_frame = false
	update_walk(delta)
	update_item_position(delta)
	update_interraction_ray()

	_is_running = Input.is_action_pressed("run")

# TODO: make an option to decide if the crouch action is a toggle or an input hold
	if Input.is_action_just_pressed("toggle_crouch"):
		toggle_crouch()
		
	# Currently: hold to crouch
	if Input.is_action_pressed("crouch"):
		crouch();
	elif not _is_crouch_locked:
		get_up()

# Common input event handling for when the player can explore freely
func exploration_input_handling(event: InputEvent):
	update_orientation(event)

func set_movement_mode(new_mode: int) -> void:
	_movement_mode = new_mode

func get_movement_mode() -> int:
	return _movement_mode

# Call this only once per _physics_update()
func update_walk(_delta) -> void:
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
		assert(false, "unhandled movement mode") 
	
	var speed = current_move_speed()
	var movement_translation = translation.normalized() * speed

	# Make sure we move towards the direction currently faced, on the "ground plane" (not the camera direction)
	var oriented_movement =  global_transform.basis.get_rotation_quat() * movement_translation
	
#	oriented_movement = never_fall_in_holes(oriented_movement)
			
	var ground_we_are_walking_on = _ground_checker.currently_walking_on()
	var debug_text = "Ground: "
	
	if ground_we_are_walking_on == GroundChecker.WalkingOn.BuildingGround:
		debug_text += "building "
			
		if not _feet_for_interior.visible:
			_feet_for_interior.visible = true
			_feet_for_interior.disabled = false
			
	elif ground_we_are_walking_on == GroundChecker.WalkingOn.OutsideGround:
		debug_text += "landscape "
		
		if _feet_for_interior.visible:
			_feet_for_interior.visible = false
			_feet_for_interior.disabled = true
	else:
		debug_text += "??? "
	
	
	var previous_origin := global_transform.origin
	
	# Apply gravity if we are walking on the ground, otherwise we are holding on a ladder or climbing
	if _movement_mode == MovementMode.Walking:
		var snap_ray := Vector3.DOWN * 10.0
		
		if ground_we_are_walking_on != GroundChecker.WalkingOn.OutsideGround:
			var gravity = global.gravity * gravity_factor
			oriented_movement += gravity
			debug_text += "with gravity "
			
			snap_ray = Vector3.ZERO
			debug_text += "no snap "
			
			
		else:
			debug_text += "no gravity but snap "
		
		_last_linear_velocity = move_and_slide_with_snap(oriented_movement, snap_ray, Vector3.UP, true, 4, deg2rad(floor_max_angle))
	else:
		_last_linear_velocity = move_and_slide(oriented_movement, Vector3.UP, true)
		
		
	debug_text += "\ninterior feet = %s " % _feet_for_interior.visible
		

	# IMPORTANT NOTE: we will try to mitigate the NaN issue by using: https://github.com/godotengine/godot/issues/50450#issuecomment-1264294986	
	if _last_linear_velocity != _last_linear_velocity:
		_last_linear_velocity = Vector3.ZERO
		print("NaN mitigation : player velocity fixed")
		
	if global_transform.origin != global_transform.origin:
		global_transform.origin = previous_origin
		print("NaN mitigation : player transform fixed")
		
	
	_debug_status.text = debug_text
	
	
	if movement_translation.length() > 0.0:
		if ground_we_are_walking_on == GroundChecker.WalkingOn.BuildingGround or _movement_mode == MovementMode.Climbing:
			_feet_audio.begin_walk(FootAudio.StepSurface.House)
		else:
			_feet_audio.begin_walk(FootAudio.StepSurface.Grass)
	else:
		_feet_audio.end_walk()
	
		
func will_fall_in_hole(oriented_movement:Vector3) -> bool:
	var original_position = _fall_checker.global_transform.origin
	var position_to_check = global_transform.origin + (oriented_movement.normalized() * fall_check_distance)
	_fall_checker.global_transform.origin = position_to_check
	var ground_distance = _fall_checker.collision_distance()
	_fall_checker.global_transform.origin = original_position
	return ground_distance == null or ground_distance >= fall_check_max_depth_allowed

func never_fall_in_holes(oriented_movement:Vector3) -> Vector3:
	if will_fall_in_hole(oriented_movement):
		return Vector3.ZERO # Dont go in holes
	else:
		return oriented_movement

func current_move_speed() -> float:
	if _movement_mode == MovementMode.Climbing:
		return climbing_speed
	elif _is_crouched:
		return crouching_speed
	else:
		if _is_running:
			return running_speed
		else:
			return walking_speed

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
	var distance_to_pointed = _interraction_ray.global_transform.origin.distance_to(_interraction_ray.get_collision_point())
	
	# Hand orientation determine held items orientation:
	if _held_item is InteractiveItem and _held_item.orientation_hand_held == InteractiveItem.TrackingOrientation.FOLLOW:
		if _interraction_ray.is_colliding() and distance_to_pointed <= auto_pointing_distance:
			# Hand need to point to whatever is pointed if we are holding an item which follows the view
			_hand_node.look_at(_interraction_ray.get_collision_point(), Vector3.UP)
		else:
			# Point at the farthest point in front of us
			var forward = -_interraction_ray.global_transform.basis.z
			var forward_position = _interraction_ray.global_transform.origin + (forward * 10)
			_hand_node.look_at(forward_position, Vector3.UP)
	else:
		# Cancel any pointing
		_hand_node.transform.basis = _initial_hand_transform.basis 
		
	
	# Interracting with interractible items:
	if _interraction_ray.is_colliding() and distance_to_pointed <= interraction_distance:
		var something = _interraction_ray.get_collider()
		if something is InteractiveItem:
			_end_pointing_usable_object()
			if _pointed_item != something and something.is_takable_now():
				_begin_pointing_interactive_item(something)
		elif utility.object_has_function(something, "player_interracts"): # Usable object (not takable like InterativeItems)
			_end_pointing_interactive_item()
			if _pointed_usable_entity != something:
				_begin_pointing_usable_object(something)
		else:
			# We are pointing at something but it's neither an InteractiveItem or something that can be used:
			_end_pointing_interactive_item()
			_end_pointing_usable_object()
	else:
		_end_pointing_interactive_item()
		_end_pointing_usable_object()

func _begin_pointing_interactive_item(item : InteractiveItem) -> void:
	if _pointed_item:
		_end_pointing_interactive_item()
	_pointed_item = item
	_pointed_item.hilite(true)
	print("Item pointed: %s" % _pointed_item.name)

func _end_pointing_interactive_item() -> void:	
	if _pointed_item is InteractiveItem:
		print("Stopped pointing item: %s" % _pointed_item.name)
		_pointed_item.hilite(false)
		_pointed_item = null

func _begin_pointing_usable_object(object:Spatial) -> void:
	if _pointed_usable_entity:
		_end_pointing_usable_object()
	print("Usable entity pointed %s" % object.name)
	_pointed_usable_entity = object
	if utility.object_has_function(_pointed_usable_entity, "on_player_begin_pointing"):
		_pointed_usable_entity.on_player_begin_pointing()
	
func _end_pointing_usable_object() -> void:
	if _pointed_usable_entity:
		print("Stopped pointing at usable entity %s" % _pointed_usable_entity.name)
		if utility.object_has_function(_pointed_usable_entity, "on_player_end_pointing"):
			_pointed_usable_entity.on_player_end_pointing()
		_pointed_usable_entity = null


func get_currently_pointed_item() -> InteractiveItem:
	return _pointed_item

func is_pointing_item() -> bool:
	return _pointed_item is InteractiveItem
	
func is_pointing_takable_item() -> bool:
	return _pointed_item is InteractiveItem && _pointed_item.is_takable_now()

func is_pointing_usable_entity() -> bool:
	return not _pointed_usable_entity == null

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
	held_item.track(_hand_node, held_item.orientation_hand_held) # TODO: Refactor so that the items script handles this

		
func begin_item_examination():
	var held_item = get_item_in_hand()
	assert(held_item is InteractiveItem)
	_examination_spot.transform = _initial_examination_transform
	held_item.track(_examination_spot)
	_is_examining = true
	held_item.begin_examination()
	examination_display.display_text_sequence([held_item.description])
	
	
func end_item_examination():
	examination_display.stop_display_sequence()
	_held_item.end_examination()
	_resume_holding_item()
	_is_examining = false

func get_examination_node() -> Spatial:
	return _examination_spot
	
func get_examination_axis() -> Vector3:
	return (_examination_spot.transform.origin - _camera.transform.origin).normalized()
	
func is_examining() -> bool:
	return _is_examining
	
func begin_center_item_holding() -> void:
	_is_holding_front = true
	var held_item = get_item_in_hand()
	assert(held_item is InteractiveItem)
	held_item.track(_center_holding_spot, held_item.orientation_held_front)

func end_center_item_holding() -> void:
	_is_holding_front = false
	_resume_holding_item()

func crouch() -> void:
	if _is_crouched:
		return
	
	var result = _crouch_tween.interpolate_property(_head, "translation", _head.transform.origin, _head_spot_crouched.transform.origin, _crouch_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	assert(result == true)
	result = _crouch_tween.start()
	assert(result == true)
	
	_body.visible = false
	_body.disabled = true
	_body_crouched.visible = true
	_body_crouched.disabled = false
	
	_is_crouched = true
	did_crouch_changed_this_frame = true
	
func get_up() -> void:
	if not _is_crouched:
		return
		
	var result = _crouch_tween.interpolate_property(_head, "translation", _head.transform.origin, _initial_head_transform.origin, _crouch_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	assert(result == true)
	result = _crouch_tween.start()
	assert(result == true)
	
	_body_crouched.visible = false
	_body_crouched.disabled = true
	_body.visible = true
	_body.disabled = false
	
	_is_crouched = false
	did_crouch_changed_this_frame = true
	
func is_crouched() -> bool:
	return _is_crouched
	
func toggle_crouch() -> void:
	print("Toggle Crouching")
	if _is_crouched:
		_is_crouch_locked = false
		get_up()
	else:
		_is_crouch_locked = true
		crouch()

func get_camera() -> Camera:
	return _camera

func use_pointed_usable_entity():
	assert(_pointed_usable_entity)
	_pointed_usable_entity.player_interracts()
	
func _toggle_debug_light() -> void:
	_debug_light.visible = not _debug_light.visible
	print("debug light: %s " % _debug_light.visible)
	
