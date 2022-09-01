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
