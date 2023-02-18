#tool
extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for child_mesh in get_children():
		if child_mesh is MeshInstance:
			child_mesh.mesh = child_mesh.mesh.duplicate(true)
			for surface_idx in child_mesh.mesh.get_surface_count():
				var material = child_mesh.mesh.surface_get_material(surface_idx)
				if material is ShaderMaterial:
					var offset = rand_range(0.5, 2.0)
					print("setting tree material offset = ", offset)
					material.set_shader_param("SwayOffset", offset)
					

