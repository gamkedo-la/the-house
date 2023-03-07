extends Spatial

onready var _eyeball : Spatial = $"%eyeball"
onready var _attention_area : Area = $"%attention_area"

export(float, 0.0, 1.0) var orientation_updates_per_secs : float = 1.0 / 13
export(float, 0.0, 100) var jitter_drift_amplitude : float = 0.1
export(float, 0.1, 10) var start_jitter_distance : float = 5
export var looks_at_player := true

onready var _last_orientation_update_time : float = utility.now_secs()
var _needs_update := false

func _ready() -> void:
	_attention_area.connect("body_entered", self, "_on_player_close")
	_attention_area.connect("body_exited", self, "_on_player_left")

func _process(delta):
	if looks_at_player and _needs_update and _eyeball.visible and global.current_player:
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
		var origin = _eyeball.global_transform.origin
		var forward = (-_eyeball.global_transform.basis.z).normalized() * 2.0
		var where_to_look_at : Vector3 = origin + forward + Vector3.UP
		_eyeball.look_at(where_to_look_at , Vector3.UP)
		_needs_update = false
