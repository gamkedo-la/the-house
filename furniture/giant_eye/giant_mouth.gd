tool
extends Spatial

export var is_open := false setget _set_open

onready var _top_lip : Spatial = $"%top_lip"
onready var _bottom_lip : Spatial = $"%bottom_lip"
onready var _top_lip_open_pos : Spatial = $"%top_lip_open_pos"
onready var _bottom_lip_open_pos : Spatial = $"%bottom_lip_open_pos"
onready var _target_top_lip_pos : Vector3
onready var _target_bottom_lip_pos : Vector3
onready var mouth_anims : AnimationPlayer = $"giant_mouth/AnimationPlayer"

class SpatialRange:
	var minimum := Vector3.ZERO
	var maximum := Vector3.ZERO

var jitter_interval := 1.0 / 3.0
onready var _last_jitter_update_time := utility.now_secs()
var top_lip_jitter_range := SpatialRange.new()
var bottom_lip_jitter_range := SpatialRange.new()

var _is_ready := false

func _ready() -> void:
	$pain_player.connect("finished", self, "start_mumbling")
	$audio_player.play()
	stop_mumbling()
	_is_ready = true
	_set_open(is_open)
#	_setup_jitter()
	mouth_anims.play("MouthMumble-loop")

func _process(_delta):
#	var now := utility.now_secs()
#	var time_passed_since_last_jitter := now - _last_jitter_update_time
#	if time_passed_since_last_jitter >= jitter_interval:
#		_last_jitter_update_time = now
#		_top_lip.transform.origin = jitter_pos(_target_top_lip_pos, top_lip_jitter_range)
#		_bottom_lip.transform.origin = jitter_pos(_target_bottom_lip_pos, bottom_lip_jitter_range)
	pass

func _setup_jitter() -> void:
	jitter_interval = 1.0 / 7.0

	top_lip_jitter_range.minimum.x = -0.01
	top_lip_jitter_range.maximum.x = 0.01

	bottom_lip_jitter_range.minimum.x = -0.01
	bottom_lip_jitter_range.maximum.x = 0.01
	bottom_lip_jitter_range.maximum.y = -0.1


static func jitter_pos(origin: Vector3, jitter_range: SpatialRange) -> Vector3:
	var x = rand_range(origin.x + jitter_range.minimum.x, origin.x + jitter_range.maximum.x)
	var y = rand_range(origin.y + jitter_range.minimum.y, origin.y + jitter_range.maximum.y)
	var z = rand_range(origin.z + jitter_range.minimum.z, origin.z + jitter_range.maximum.z)
	return Vector3(x, y, z)

func open_mouth() -> void:
	if _is_ready:
		_top_lip.transform.origin = _top_lip_open_pos.transform.origin
		_bottom_lip.transform.origin = _bottom_lip_open_pos.transform.origin
		_target_top_lip_pos = _top_lip.transform.origin
		_target_bottom_lip_pos = _bottom_lip.transform.origin
	is_open = true
	mouth_anims.play("MouthOpen")
	play_pain()
	stop_mumbling()
	print("giant mouth open")

func close_mouth() -> void:
#	if _is_ready:
#		_top_lip.transform.origin = Vector3.ZERO
#		_bottom_lip.transform.origin = Vector3.ZERO
#		_target_top_lip_pos = _top_lip.transform.origin
#		_target_bottom_lip_pos = _bottom_lip.transform.origin
	mouth_anims.play_backwards("MouthOpen")
	is_open = false
	print("giant mouth closed")


func _set_open(new_value : bool) -> void:
	if new_value:
		open_mouth()
	else:
		close_mouth()

func play_pain() -> void:
	stop_mumbling()
	$pain_player.play()

func start_mumbling() -> void:
	$audio_player.unit_db = -6

func stop_mumbling() -> void:
	$audio_player.unit_db = -80
