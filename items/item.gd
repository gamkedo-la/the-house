extends RigidBody
class_name InteractiveItem

signal use_item
signal snapping_into_position

export var can_be_taken = true
export var hilighted = false

export var highlightable := true
export var highlight_color : Color = "#ffffff"
export var highlight_width := 5.0
export var mesh_node: NodePath

enum TrackingOrientation {
	NONE, # The item will not orient itself at all.
	FOLLOW, # The item will follow the orientation being tracked.
	FOLLOW_Y, # The item will orient like the tracked node but will not rotate on the plane XZ.
}

export(TrackingOrientation) var orientation_hand_held = TrackingOrientation.FOLLOW
export(TrackingOrientation) var orientation_held_front = TrackingOrientation.FOLLOW_Y


onready var hilite_mat = load("res://shaders/hilite_material.tres")

var _tracking_position = Spatial
var _tracking_rotation_enabled = TrackingOrientation.FOLLOW
var _is_taken := false

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
				var item_mat = hilit_mesh.surface_get_material(0)
				if !item_mat:
					item_mat = ShaderMaterial.new()
				hilit_mesh.surface_set_material(0, item_mat.duplicate(true))
				item_mat = hilit_mesh.surface_get_material(0)
				var hilite_m = hilite_mat.duplicate(true)
				item_mat.set_next_pass(hilite_m)
				var item_mat_next = item_mat.get_next_pass()
				item_mat_next.set_shader_param("outline_color", highlight_color)
				
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

func is_takable_now() -> bool :
	return can_be_taken && not _is_taken

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

func take(hold_where: Spatial) -> void:
	assert(can_be_taken)
	assert(not _is_taken)
	track(hold_where, orientation_hand_held)
	_set_collision_with_player(self, false) # stop colliding with the player
	_cancel_velocity(self)
	set_mode(RigidBody.MODE_RIGID) # Once taken, even if the object was static before, it is now following physics laws.
	_is_taken = true

	
func drop(where: Spatial) -> void:
	stop_tracking()
	global_transform.origin = where.global_transform.origin
	global_transform.basis = where.global_transform.basis
	_set_collision_with_player(self, true) # resume colliding with the player
	_cancel_velocity(self)
	sleeping = false
	_is_taken = false
	
	
func update_movement(delta:float, base_linear_velocity:Vector3 = Vector3.ZERO) -> void:
	if not _tracking_position:
		return
	var translation_to_target : Vector3 = _tracking_position.global_transform.origin - global_transform.origin
	var item_linear_velocity : Vector3 = translation_to_target * _tracking_speed * delta
	linear_velocity = base_linear_velocity + item_linear_velocity
		
	var orientation_to_track : Basis = Basis.IDENTITY
	match _tracking_rotation_enabled:
		TrackingOrientation.FOLLOW:
			orientation_to_track = _tracking_position.global_transform.basis
		TrackingOrientation.FOLLOW_Y:
			orientation_to_track = orientation_to_track.rotated(Vector3.UP, _tracking_position.global_transform.basis.get_euler().y)
		
		
	var rotation_to_target_direction := utility.calc_angular_velocity(global_transform.basis, orientation_to_track)
	angular_velocity = rotation_to_target_direction * _tracking_angular_speed * delta
		
	
func track(target: Spatial, enable_rotation_tracking := TrackingOrientation.FOLLOW):
	_tracking_position = target
	_tracking_rotation_enabled = enable_rotation_tracking
	
func stop_tracking() -> void:
	_tracking_position = null
	
func snap_to(target: Spatial) -> void:
	assert(target)
	print("snapping into position")
	emit_signal("snapping_into_position") # We emit this signal early to let the player's code react 
	stop_tracking()
	# mode = RigidBody.MODE_STATIC
	can_be_taken = false
	sleeping = true
	get_parent().remove_child(self)
	target.add_child(self)
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	transform.origin = Vector3.ZERO
	global_transform.origin = target.global_transform.origin
	global_transform.basis = target.global_transform.basis
