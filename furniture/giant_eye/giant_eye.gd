extends Spatial

onready var _eyeball : Spatial = $"%eyeball"
onready var _eyelid_up : Spatial = $"%eyelid_up"
onready var _eyelid_down : Spatial = $"%eyelid_down"
onready var _eyelid_up_closed : Spatial = $"%eyelid_up_closed"
onready var _eyelid_down_closed : Spatial = $"%eyelid_down_closed"
onready var _attention_area : Area = $"%attention_area"
onready var _flame_intolerance_area : LightableArea = $flame_intolerance_area

export(float, 0.0, 1.0) var orientation_updates_per_secs : float = 1.0 / 13
export(float, 0.0, 100) var jitter_drift_amplitude : float = 0.1
export(float, 0.1, 10) var start_jitter_distance : float = 5
export var looks_at_player := true
export var is_open := true

signal on_eye_closed()
signal on_eye_opened()

onready var _last_orientation_update_time : float = utility.now_secs()
var _needs_update := false

var _initial_eyelid_up_pos : Vector3
var _initial_eyelid_down_pos : Vector3

func _ready() -> void:
	_attention_area.connect("body_entered", self, "_on_player_close")
	_attention_area.connect("body_exited", self, "_on_player_left")
	_flame_intolerance_area.connect("lit_using_fire", self, "_on_flame_is_too_close")
	
	_initial_eyelid_up_pos = _eyelid_up.transform.origin
	_initial_eyelid_down_pos = _eyelid_down.transform.origin

func _process(delta):
	if looks_at_player and _needs_update and _eyeball.visible and global.current_player:
		_update_eye_looking_at_player()
		
	

func _update_eye_looking_at_player() -> void:
	var now = utility.now_secs()
	var time_since_last_update = now - _last_orientation_update_time
	if time_since_last_update >= orientation_updates_per_secs:
		var node_to_look_at : Spatial = global.current_player.get_node("Head/Camera")
		_eyeball.look_at(node_to_look_at.global_transform.origin, Vector3.UP)

		var distance_to_player : float = node_to_look_at.global_transform.origin.distance_to(_eyeball.global_transform.origin)
		var distance_ratio : float = 1.0 - (distance_to_player / start_jitter_distance)
		var actual_jitter = lerp(0.0, jitter_drift_amplitude, ease(distance_ratio, -4.0)) # see https://docs.godotengine.org/en/3.5/classes/class_@gdscript.html#class-gdscript-method-ease
		var shifted_orientation = _eyeball.global_transform.basis.rotated(Vector3.RIGHT, rand_range(-actual_jitter, actual_jitter))
		shifted_orientation = shifted_orientation.rotated(Vector3.UP, rand_range(-actual_jitter, actual_jitter))
		_eyeball.global_transform.basis = shifted_orientation

		_last_orientation_update_time = now
		
func _on_player_close(player) -> void:
	if player is Player:
		_needs_update = true

func _on_player_left(player) -> void:
	if player is Player:
		_reset_eye_orientation()

func _reset_eye_orientation() -> void:
	var origin = _eyeball.global_transform.origin
	var forward = (-_eyeball.global_transform.basis.z).normalized() * 2.0
	var where_to_look_at : Vector3 = origin + forward + Vector3.UP
	_eyeball.look_at(where_to_look_at , Vector3.UP)
	_needs_update = false

func _on_flame_is_too_close() -> void:
	print("giant eye: flame is too close!")
	close_eye()
	
	
func close_eye():
	_eyelid_up.transform.origin = _eyelid_up_closed.transform.origin
	_eyelid_down.transform.origin = _eyelid_down_closed.transform.origin
	_eyeball.visible = false
	_flame_intolerance_area.set_deferred("monitoring", false)
	_attention_area.set_deferred("monitoring", false)
	is_open = false
	print("giant eye: closed")
	emit_signal("on_eye_closed")
	
func open_eye():
	_eyelid_up.transform.origin = _initial_eyelid_up_pos
	_eyelid_down.transform.origin = _initial_eyelid_down_pos
	_eyeball.visible = true
	_reset_eye_orientation()
	_flame_intolerance_area.set_deferred("monitoring", true)
	_attention_area.set_deferred("monitoring", true)
	is_open = true
	print("giant eye: open")
	emit_signal("on_eye_opened")
	

