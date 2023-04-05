extends Object

class_name box_conversions

static func convert_csg_box_to_collision_box(csg_box : CSGBox) -> CollisionShape:
	var box_shape = BoxShape.new()
	box_shape.extents = Vector3(csg_box.width / 2.0, csg_box.height / 2.0, csg_box.depth / 2.0)

	var collision_box = CollisionShape.new()
	collision_box.shape = box_shape

	collision_box.global_transform = csg_box.global_transform

	return collision_box




