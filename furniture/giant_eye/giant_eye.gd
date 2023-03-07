extends Spatial

onready var _eyeball : Spatial = $"%eyeball"
onready var _attention_area : Area = $"%attention_area"

export(float, 0.0, 1.0) var orientation_updates_per_secs : float = 1.0 / 3
export(float, 0.0, 100) var jitter_drift_amplitude : float = 0.1
export(float, 0.1, 10) var start_jitter_distance : float = 3
export var looks_at_player := false

onready var _last_orientation_update_time : float = utility.now_secs()

# The following is commented for performance reasons. To fix the performance issue, we need to completely replace the placeholders by actual meshes. CSG stuffs dont like to be moving all the time.
#
#func _process(delta):
#	if looks_at_player and _eyeball.visible and global.current_player and _attention_area.overlaps_body(global.current_player):
#		var time_since_last_update = utility.now_secs() - _last_orientation_update_time
#		if time_since_last_update >= orientation_updates_per_secs:
#			var node_to_look_at : Spatial = global.current_player.get_node("Head/Camera")
#			_eyeball.look_at(node_to_look_at.global_transform.origin, Vector3.UP)
#
#			var distance_to_player : float = node_to_look_at.global_transform.origin.distance_to(_eyeball.global_transform.origin)
#			var distance_ratio : float = 1.0 - (distance_to_player / start_jitter_distance)
#			var actual_jitter = lerp(0.0, jitter_drift_amplitude, ease(distance_ratio, -4.0)) # see https://docs.godotengine.org/en/3.5/classes/class_@gdscript.html#class-gdscript-method-ease
#			var shifted_orientation = _eyeball.global_transform.basis.rotated(Vector3.RIGHT, rand_range(-actual_jitter, actual_jitter))
#			shifted_orientation = shifted_orientation.rotated(Vector3.UP, rand_range(-actual_jitter, actual_jitter))
#			_eyeball.global_transform.basis = shifted_orientation
#
#			_last_orientation_update_time = time_since_last_update
#
