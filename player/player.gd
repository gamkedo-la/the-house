extends KinematicBody

class_name Player

var walk_speed = 500.0
var view_speed = 0.002 # TODO: make this a game setting

var _gravity = Vector3(0.0, -ProjectSettings.get_setting("physics/3d/default_gravity"), 0.0)

onready var _camera = $"%Camera"
onready var _interraction_ray: RayCast = $"%InterractionRay"
onready var _hand_node = $"right_hand"
onready var _pixelator = $"%Camera/screen pixelation"
onready var _state_machine : PlayerStateMachine = $"PlayerStateMachine"
var _hilited_items = []

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # TODO: have a way to switch that on/off
	
func _ready():
	_state_machine.start_with_player(self)

func _process(delta):
#	_state_machine.update(delta)	
	# TEMPORARY:
	if Input.is_action_just_pressed("debug_switch_pixelator"):
		print("F10")
		if _pixelator.visible:
			_pixelator.hide()
		else:
			_pixelator.show()
			
	if Input.is_action_just_pressed("debug_switch_light_source"):
		var lighter = $"%Camera/lighter"
		var torch = $"%Camera/torchlight"
		if lighter.visible:
			lighter.hide()
			torch.show()
		else:
			lighter.show()
			torch.hide()

# Call this only once per _physics_update()
func update_walk(delta) -> void:
	var translation = Vector3()

	# TODO: replace these actions by game specific actions "walk_left" etc.
	if Input.is_action_pressed("ui_left"):
		translation += Vector3.LEFT

	if Input.is_action_pressed("ui_right"):
		translation += Vector3.RIGHT

	if Input.is_action_pressed("ui_up"):
		translation += Vector3.FORWARD

	if Input.is_action_pressed("ui_down"):
		translation += Vector3.BACK

	var movement_translation = translation.normalized() * walk_speed * delta
	# Make sure we move towards the direction currently faced, on the "ground plane" (not the camera direction)
	var oriented_movement =  global_transform.basis.get_rotation_quat() * movement_translation

	move_and_slide(oriented_movement + _gravity, Vector3.UP, true)

# Call this only once per _input() or _unhandled_input()
func update_orientation(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		rotate_y(-event.relative.x * view_speed)
		_camera.rotate_x(-event.relative.y * view_speed)
	

func update_interraction_ray() -> void:
	if _interraction_ray.is_colliding():
		var obj = _interraction_ray.get_collider()
		if obj is InteractiveItem and obj.has_method("hilite"):
				_hilited_items.append(obj)
				obj.hilite(true)
	else:
		for item in _hilited_items:
			item.hilite(false)
		_hilited_items.clear()



func get_item_in_hand() -> Node:
	return _hand_node.get_child(0)
	
func is_holding_item() -> bool:
	return get_item_in_hand() != null
	
func take_item(item_node: Node) -> void:
	assert(item_node)
	item_node.parent().remove_child(item_node)
	_hand_node.add_child(item_node)
	
func drop_item() -> void:
	var item = get_item_in_hand()
	assert(item is Node)
	_hand_node.remove_child(item)

