#tool
extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Calculate offset once per instance so that trunk + leaves move in sync
	# with each other.
	# FIXME: SwayOffset doenst do what we need (having the trees not be in sync)
	pass
#	var offset = rand_range(0, 10000)
#	for meshi in get_children():
#		if meshi is MeshInstance:
#			for i in meshi.get_surface_material_count():
#				var material = meshi.get_surface_material(i)
##				print("blah")
#				material.set_shader_param("SwayOffset", offset)
