tool
extends EditorScript

func _run() -> void:
	_add_collision_box_from_csgbox(get_scene())


func _add_collision_box_from_csgbox(node: Node) -> void:
	if node is CSGBox:
		var collision_box = box_conversions.convert_csg_box_to_collision_box(node)
		get_scene().add_child(collision_box)
		collision_box.set_owner(get_scene())
		print("new collision box : %s" % collision_box.name)

	for child in node.get_children():
		_add_collision_box_from_csgbox(child)

