extends KinematicBody

var walk_speed = 1000.0
var view_speed = 0.01

var gravity = Vector3(0.0, -ProjectSettings.get_setting("physics/2d/default_gravity"), 0.0)

onready var camera = $Head/Camera

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # TODO: have a way to switch that on/off

func _process(delta):
#	print("player transform : ", transform)
	pass

func _physics_process(delta):
	update_walk(delta)


func update_walk(delta):
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

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * view_speed)
		camera.rotate_x(-event.relative.y * view_speed)
		
	
	
