tool
extends Spatial

export var is_open := false setget _set_open

onready var _top_lip : Spatial = $"%top_lip"
onready var _bottom_lip : Spatial = $"%bottom_lip"
onready var _top_lip_open_pos : Spatial = $"%top_lip_open_pos"
onready var _bottom_lip_open_pos : Spatial = $"%bottom_lip_open_pos"

var _is_ready := false

func _ready() -> void:
	_is_ready = true
	_set_open(is_open)

func open_mouth() -> void:
	if _is_ready:
		_top_lip.transform.origin = _top_lip_open_pos.transform.origin
		_bottom_lip.transform.origin = _bottom_lip_open_pos.transform.origin
	is_open = true
	print("giant mouth open")

func close_mouth() -> void:
	if _is_ready:
		_top_lip.transform.origin = Vector3.ZERO
		_bottom_lip.transform.origin = Vector3.ZERO
	is_open = false
	print("giant mouth closed")


func _set_open(new_value : bool) -> void:
	if new_value:
		open_mouth()
	else:
		close_mouth()

