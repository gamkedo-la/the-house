extends RigidBody
class_name InteractiveItem

signal use_item

export var hilighted = false

export (bool) var highlightable = true
export (Color) var highlight_color = "#ff6f00"
export (float) var highlight_width = 5.0
export (NodePath) var mesh_node
onready var hilite_mat = load("res://shaders/hilite_material.tres")
var hilite_mesh: Mesh
var item_mat: Material
var item_mat_next: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	# Does this item 'glow' when the player hovers over it?
	if highlightable:
		_init_hilite()
	pass # Replace with function body.
		
func _init_hilite() -> void:
	if self is RigidBody:
		set_collision_layer_bit(7, true)
	for child in get_children():
		if child is MeshInstance:
			child.mesh = child.get_mesh().duplicate(true)
			hilite_mesh = child.get_mesh()
			if hilite_mesh:
				var hilite_m = hilite_mat.duplicate(true)
				hilite_mesh.surface_set_material(0, hilite_mesh.surface_get_material(0).duplicate(true))
				item_mat = hilite_mesh.surface_get_material(0)
				item_mat.set_next_pass(hilite_m)
				item_mat_next = item_mat.get_next_pass()
				item_mat_next.set_shader_param("color", highlight_color)
		
func is_hilighted()-> bool:
	return hilighted
	
func hilite(toggle: bool) -> void:
	hilighted = toggle
	if hilite_mesh:
		if hilighted:
			item_mat_next.set_shader_param("outline_width",highlight_width)
		else:
			item_mat_next.set_shader_param("outline_width",0.0)

func activate():
	emit_signal("use_item")
			
func take():
	mode = MODE_KINEMATIC
	
func drop():
	mode = MODE_RIGID
	sleeping = false
