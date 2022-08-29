extends RigidBody
class_name InteractiveItem

signal use_item

export var hilighted = false

export var highlightable := true
export var highlight_color : Color  = "#ff6f00"
export var highlight_width := 5.0
export var mesh_node: NodePath
onready var hilite_mat = load("res://shaders/hilite_material.tres")


const player_collision_layer_bit := 0
const player_interraction_raycast_layer_bit := 7

class MeshHighlight:
	var mesh : Mesh
	var item_mat: Material
	var item_mat_next: ShaderMaterial
	
var highlites := []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Does this item 'glow' when the player hovers over it?
	if highlightable:
		highlites = _init_hilite(self, hilite_mat, highlight_color)
	pass # Replace with function body.
		
static func _init_hilite(node: Node, hilite_mat: Material, highlight_color: Color) -> Array:
	var highlites := []
	if node is RigidBody:
		node.set_collision_layer_bit(player_interraction_raycast_layer_bit, true)
	for child in node.get_children():
		if child is MeshInstance:
			child.mesh = child.get_mesh().duplicate(true)
			var hilit_mesh = child.get_mesh()
			if hilit_mesh:
				var mesh_highlit = MeshHighlight.new()
				hilit_mesh.surface_set_material(0, hilit_mesh.surface_get_material(0).duplicate(true))
				var item_mat = hilit_mesh.surface_get_material(0)
				var hilite_m = hilite_mat.duplicate(true)
				item_mat.set_next_pass(hilite_m)
				var item_mat_next = item_mat.get_next_pass()
				item_mat_next.set_shader_param("color", highlight_color)
				
				mesh_highlit.mesh = hilit_mesh
				mesh_highlit.item_mat = item_mat
				mesh_highlit.item_mat_next = item_mat_next
				highlites.append(mesh_highlit)
		highlites = highlites + _init_hilite(child, hilite_mat, highlight_color)
	return highlites
		
func is_hilighted()-> bool:
	return hilighted
	
func hilite(toggle: bool) -> void:
	hilighted = toggle
	if highlites.size() > 0:
		if hilighted:
			for slot in highlites:
				slot.item_mat_next.set_shader_param("outline_width",highlight_width)
		else:
			for slot in highlites:
				slot.item_mat_next.set_shader_param("outline_width",0.0)

func activate():
	emit_signal("use_item")


static func _set_collision_with_player(node: Node, set_enabled: bool):
	if node is RigidBody:
		node.set_collision_layer_bit(player_collision_layer_bit, set_enabled) 
	for child_node in node.get_children():
		_set_collision_with_player(child_node, set_enabled)
		

func take(hold_where: Transform):
	global_transform.origin = hold_where.origin
	global_transform.basis = hold_where.basis
	mode = MODE_KINEMATIC
	_set_collision_with_player(self, false) # stop colliding with the player
	linear_velocity = Vector3.ZERO;
	angular_velocity = Vector3.ZERO;

	
func drop(where: Transform):
	global_transform.origin = where.origin
	global_transform.basis = where.basis
	mode = MODE_RIGID
	_set_collision_with_player(self, true) # resume colliding with the player
	sleeping = false	
	linear_velocity = Vector3.ZERO;
	angular_velocity = Vector3.ZERO;
	
	
