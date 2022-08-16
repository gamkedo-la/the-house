extends KinematicBody

class_name Player

var walk_speed = 500.0
var view_speed = 0.002 # TODO: make this a game setting

var gravity = Vector3(0.0, -ProjectSettings.get_setting("physics/3d/default_gravity"), 0.0)

onready var camera = $"%Camera"
onready var interraction_ray: RayCast = $"%InterractionRay"
onready var pixelator = $"%Camera/screen pixelation"
onready var state_machine : PlayerStateMachine = $"PlayerStateMachine"
var hilited_items = []

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # TODO: have a way to switch that on/off
	
func _ready():
	state_machine.start_with_player(self)

func _process(delta):
#	_state_machine.update(delta)	
	# TEMPORARY:
	if Input.is_action_just_pressed("debug_switch_pixelator"):
		print("F10")
		if pixelator.visible:
			pixelator.hide()
		else:
			pixelator.show()
			
	if Input.is_action_just_pressed("debug_switch_light_source"):
		var lighter = $"%Camera/lighter"
		var torch = $"%Camera/torchlight"
		if lighter.visible:
			lighter.hide()
			torch.show()
		else:
			lighter.show()
			torch.hide()
	####
#
#func _physics_process(delta):
##	_state_machine.physics_update(delta)
#	_update_walk(delta)
#	_item_ray_check()
#
#func _input(event):
##	_state_machine.input_update(event)
#	_update_orientation(event)
#

func _update_walk(delta) -> void:
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

	move_and_slide(oriented_movement + gravity, Vector3.UP, true)

func _update_orientation(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		rotate_y(-event.relative.x * view_speed)
		camera.rotate_x(-event.relative.y * view_speed)
	

func _item_ray_check() -> void:
	if interraction_ray.is_colliding():
		var obj = interraction_ray.get_collider()
		if obj is InteractiveItem and obj.has_method("hilite"):
				hilited_items.append(obj)
				obj.hilite(true)
	else:
		for item in hilited_items:
			item.hilite(false)
		hilited_items.clear()
	

	
	
