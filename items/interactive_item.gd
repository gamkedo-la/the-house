extends RigidBody
class_name InteractiveItem

signal use_item(item)
signal snapping_into_position(item)
signal on_taken_by_player(item)
signal on_dropped_by_player(item)
signal on_examination_begin(item)
signal on_examination_end(item)
signal on_snapped_into_fixed_position(item)

export var can_be_taken = true
export var hilighted = false

export var highlightable := true
export var highlight_color : Color = "#ffffff"
export var highlight_width := 5.0

enum TrackingOrientation {
	NONE, # The item will not orient itself at all.
	FOLLOW, # The item will follow the orientation being tracked.
	FOLLOW_Y, # The item will orient like the tracked node but will not rotate on the plane XZ.
}

export(TrackingOrientation) var orientation_hand_held = TrackingOrientation.FOLLOW
export(TrackingOrientation) var orientation_held_front = TrackingOrientation.FOLLOW_Y

export var description : String = ""


var _previous_global_transform_origin : Vector3

onready var hilite_mat = load("res://shaders/hilite_material.tres")

var _tracking_position = Spatial
var _tracking_rotation_enabled = TrackingOrientation.FOLLOW
var _is_taken := false

const _tracking_speed := 1000.0
const _tracking_angular_speed := 1000.0


class MeshHighlight:
	var item_mat: Material
	var item_mat_next: ShaderMaterial
	
var highlites := []

# Called when the node enters the scene tree for the first time.
func _ready():
	_previous_global_transform_origin = global_transform.origin
	# Does this item 'glow' when the player hovers over it?
	if highlightable:
		highlites = _init_hilite(self, hilite_mat, highlight_color)
	
static func _create_hilite(mesh_instance: MeshInstance, hilite_mat: Material, highlight_color: Color) -> Array:
	var highlites := []
	for surface_idx in mesh_instance.get_surface_material_count():
		var item_mat := mesh_instance.get_active_material(surface_idx)
		if !item_mat:
			item_mat = ShaderMaterial.new()
		mesh_instance.set_surface_material(surface_idx, item_mat.duplicate(true))
		item_mat = mesh_instance.get_active_material(surface_idx)
		var hilite_m := hilite_mat.duplicate(true)
		item_mat.set_next_pass(hilite_m)
		var item_mat_next = item_mat.get_next_pass()
		item_mat_next.set_shader_param("outline_color", highlight_color)
		
		var mesh_highlit = MeshHighlight.new()
		mesh_highlit.item_mat = item_mat
		mesh_highlit.item_mat_next = item_mat_next
		highlites.push_back(mesh_highlit)
		
	return highlites

static func _init_hilite(node: Node, hilite_mat: Material, highlight_color: Color) -> Array:
	var highlites := []
	if node is RigidBody:
		node.set_collision_layer_bit(CollisionLayers.player_interraction_raycast_layer_bit, true)
	elif node is MeshInstance:
		var mesh_highlites = _create_hilite(node, hilite_mat, highlight_color)
		highlites.append_array(mesh_highlites)
		
	for child in node.get_children():
		var child_highlights = _init_hilite(child, hilite_mat, highlight_color)
		highlites.append_array(child_highlights)
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
	emit_signal("use_item", self)

func is_takable_now() -> bool :
	return can_be_taken && not _is_taken

static func _set_collision_with_player(node: Node, set_enabled: bool):
	if node is RigidBody:
		node.set_collision_layer_bit(CollisionLayers.player_collision_layer_bit, set_enabled) 
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
	continuous_cd = true # Turn on precise handling of collisions
	_is_taken = true
	emit_signal("on_taken_by_player", self)

	
func drop(where: Spatial) -> void:
	stop_tracking()
	global_transform.origin = where.global_transform.origin
	global_transform.basis = where.global_transform.basis
	_set_collision_with_player(self, true) # resume colliding with the player
	_cancel_velocity(self)
	linear_velocity = global.gravity.normalized()
	sleeping = false # Makes sure it starts falling
	continuous_cd = false # Turn off precise handling of collisions
	_is_taken = false
	emit_signal("on_dropped_by_player", self)
	
	
func update_movement(delta:float, base_linear_velocity:Vector3 = Vector3.ZERO) -> void:
	assert(base_linear_velocity == base_linear_velocity) # NaN issues mitigation
	
	if not _tracking_position:
		return
		
	if _tracking_position.global_transform.origin != _tracking_position.global_transform.origin:
		print("NaN mitigation item: _tracking_position.global_transform.origin is NaN???")
		
	if global_transform.origin != global_transform.origin:
		global_transform.origin = _previous_global_transform_origin
		print("NaN mitigation item: global_transform.origin fixed")
	_previous_global_transform_origin = global_transform.origin
		
	var translation_to_target : Vector3 = _tracking_position.global_transform.origin - global_transform.origin
	if translation_to_target != translation_to_target:
		print("NaN mitigation item: translation_to_target is NaN???")
		
	var item_linear_velocity : Vector3 = translation_to_target * _tracking_speed * delta
	if item_linear_velocity != item_linear_velocity:
		print("NaN mitigation item: item_linear_velocity is NaN???")
	
	var new_velocity = base_linear_velocity + item_linear_velocity
	if new_velocity != new_velocity: # NaN issues mitigation
		new_velocity = Vector3.ZERO
		print("NaN mitigation item: item new velocity fixed")
		
	linear_velocity = new_velocity
		
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
	mode = RigidBody.MODE_STATIC
	can_be_taken = false
	sleeping = true
	get_parent().remove_child(self)
	target.add_child(self)
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	transform.origin = Vector3.ZERO
	global_transform.origin = target.global_transform.origin
	global_transform.basis = target.global_transform.basis
	emit_signal("on_snapped_into_fixed_position", self)
	
func begin_examination() -> void:
	emit_signal("on_examination_begin", self)
	
func end_examination() -> void:
	emit_signal("on_examination_end", self)
	
	
	
