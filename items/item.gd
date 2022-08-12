extends Node
class_name InteractiveItem

signal use_item

export var hilighted = false

export var item_held = false
export (NodePath) var mesh_node
var hilite_mesh: MeshInstance
var item_mat: Material
var item_mat_next: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	hilite_mesh = get_node_or_null(mesh_node)
	if hilite_mesh:
		item_mat = hilite_mesh.get_surface_material(0)
		item_mat.set_next_pass(item_mat.get_next_pass().duplicate())
		item_mat_next = item_mat.get_next_pass()
		
	pass # Replace with function body.

func _input(event):
	if item_held and event is InputEventKey and event.scancode == KEY_Q and event.pressed and not event.echo:
		emit_signal("use_item")

func hilite(toggle: bool) -> void:
	hilighted = toggle
	if hilite_mesh:
		if hilighted:
			item_mat_next.set_shader_param("outline_width",5.0)
		else:
			item_mat_next.set_shader_param("outline_width",0.0)
