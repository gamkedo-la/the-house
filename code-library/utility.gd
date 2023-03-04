extends Object

# PUT ONLY STATIC FUNCTIONS HERE
class_name utility

static func calc_angular_velocity(from_basis: Basis, to_basis: Basis) -> Vector3:
	# source: https://www.reddit.com/r/godot/comments/q1lawy/comment/hfoz646/?utm_source=share&utm_medium=web2x&context=3
	var q1 := from_basis.get_rotation_quat()
	var q2 := to_basis.get_rotation_quat()
	
	# Quaternion that transforms q1 into q2
	var qt := q2 * q1.inverse()
	
	# Angle from quaternion
	var angle := 2 * acos(qt.w)

	# There are two distinct quaternions for any orientation.
	# Ensure we use the representation with the smallest angle.
	if angle > PI:
		qt = -qt
		angle = TAU - angle
	
	# Prevent divide by zero
	if angle < 0.0001:
		return Vector3.ZERO
	
	# Axis from quaternion
	var axis := Vector3(qt.x, qt.y, qt.z) / sqrt(1-qt.w*qt.w)
	
	return axis * angle


static func random_selection(array: Array):
	var selected = array[ randi() % array.size() ]
	return selected
	
static func random_vector2(width: float, origin: Vector2 = Vector2.ZERO) -> Vector2:
	return Vector2(origin.x + rand_range(-width, width), origin.y + rand_range(-width, width));

static func nan_to_zero(vec: Vector3) -> Vector3:
	if is_nan(vec.x):
		vec.x = 0
	if is_nan(vec.y):
		vec.y = 0
	if is_nan(vec.z):
		vec.z = 0
	return vec

# TODO: add support for values to pass
static func apply_recursively(root_node: Node, work_on_node: FuncRef, apply_to_root: bool = true) -> void:
	if apply_to_root:
		work_on_node.call_func(root_node)

	# We go breadth-first:
	for child_node in root_node.get_children():
		work_on_node.call_func(child_node)
		
	for child_node in root_node.get_children():
		apply_recursively(child_node, work_on_node, false) # Make sure it is not applied to the child node twice.

static func delete_child(parent : Node, child: Node):
	# source: https://www.reddit.com/r/godot/comments/9qmjfj/remove_all_children/
	parent.remove_child(child)
	child.queue_free()
	
static func delete_children(node : Node):
	# source: https://www.reddit.com/r/godot/comments/9qmjfj/remove_all_children/
	for child_node in node.get_children():
		delete_child(node, child_node)
	
static func object_has_signal( object: Object, signal_name: String ) -> bool:
	# source: https://www.reddit.com/r/godot/comments/8bklwt/check_if_node_has_signal/
	var list = object.get_signal_list()
	
	for signal_entry in list:
		if signal_entry["name"] == signal_name:
			return true
		
	return false

static func random_direction_on_xz_plan(node: Spatial) -> void:
	node.global_transform.basis = node.global_transform.basis.rotated(Vector3.UP, rand_range(deg2rad(0), deg2rad(360)))
	
	
static func centered_text(text: String) -> String:
	return "[center]%s[/center]" % text

static func now_secs() -> float:
	return Time.get_ticks_msec() * 0.001
	
