extends Spatial


onready var window_cam: Camera = $WindowView/Camera
onready var window_cam_holder: Spatial = $WindowCamHolder
onready var window_port: Viewport = $WindowView
onready var window_anchor: Spatial = $WindowAnchor
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta) -> void:
	move_camera()
	sync_viewport()
	pass

func get_camera() -> Camera:
	if Engine.is_editor_hint():
		return get_node("/root/EditorCameraProvider").get_camera()
	else:
		return get_viewport().get_camera()


func move_camera() -> void:
	var trans = window_anchor.global_transform.inverse() * get_camera().global_transform
	trans = trans.rotated(Vector3.UP, PI)
	window_cam_holder.transform = trans
	var cam_pos: Transform = window_cam_holder.global_transform
	window_cam.global_transform = cam_pos
	window_cam.global_transform.origin += Vector3(0,2,0)
#	print_debug("Camera Xform: ", get_camera().global_transform, " WindowCam XForm: ", window_cam.global_transform )

func sync_viewport() -> void:
	window_port.size = get_viewport().size
