extends RigidBody
class_name InteractiveItem

signal use_item

export var hilighted = false

export var item_held = false
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

func _input(event):
	if item_held and event is InputEventKey and event.scancode == KEY_Q and event.pressed and not event.echo:
		emit_signal("use_item")
		
func _init_hilite() -> void:
	if self is RigidBody:
		set_collision_layer_bit(7, true)
	for child in get_children():
		if child is MeshInstance:
#			print_debug(child)
			hilite_mesh = child.get_mesh()
			if hilite_mesh:
				var hilite_m = hilite_mat
				item_mat = hilite_mesh.surface_get_material(0)
				item_mat.set_next_pass(hilite_m)
				item_mat_next = item_mat.get_next_pass()
				item_mat_next.set_shader_param("color", highlight_color)
		
func hilite(toggle: bool) -> void:
	hilighted = toggle
	if hilite_mesh:
		if hilighted:
			item_mat_next.set_shader_param("outline_width",highlight_width)
		else:
			item_mat_next.set_shader_param("outline_width",0.0)
