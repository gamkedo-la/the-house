extends RigidBody
class_name InteractiveItem

signal use_item

export var hilighted = false

export var highlightable := true
export var highlight_color : Color  = "#ff6f00"
export var highlight_width := 5.0
export var mesh_node: NodePath
onready var hilite_mat = load("res://shaders/hilite_material.tres")

var _tracking_position = Node
const _tracking_speed := 500.0
const _tracking_angular_speed := 1000.0

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

static func _cancel_velocity(node: Node):
	if node is RigidBody:
		node.linear_velocity = Vector3.ZERO
		node.angular_velocity = Vector3.ZERO
	for child_node in node.get_children():
		_cancel_velocity(child_node)

func take(hold_where: Node):
	_tracking_position = hold_where
	_set_collision_with_player(self, false) # stop colliding with the player
	_cancel_velocity(self)

	
func drop(where: Node):
	_tracking_position = null
	global_transform.origin = where.global_transform.origin
	global_transform.basis = where.global_transform.basis
	_set_collision_with_player(self, true) # resume colliding with the player
	_cancel_velocity(self)
	sleeping = false
	
	
func update_movement(delta:float, base_linear_velocity:Vector3 = Vector3.ZERO) -> void:
	if not _tracking_position:
		return
	var translation_to_target : Vector3 = _tracking_position.global_transform.origin - global_transform.origin
	var item_linear_velocity : Vector3 = translation_to_target * _tracking_speed * delta
	linear_velocity = base_linear_velocity + item_linear_velocity
		
	var rotation_to_target_direction := utility.calc_angular_velocity(global_transform.basis, _tracking_position.global_transform.basis)
	angular_velocity = rotation_to_target_direction * _tracking_angular_speed * delta
	
