#tool
extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Calculate offset once per instance so that trunk + leaves move in sync
	# with each other.
	var offset = rand_range(0.5, 2.0)
	for i in $pine2.get_surface_material_count():
		var material = $pine2.get_surface_material(i)
		material.set_shader_param("SwayOffset", offset)
