
tool

extends InteractiveItem
class_name Mushroom


onready var _models_node : Spatial = $"models"
onready var _light_node : OmniLight = $"light"
onready var _lighten_area : Area = $"%lighten_area"
onready var _lighten_area_shape : CollisionShape = $"%lighten_area/CollisionShape"
onready var _player : Player

enum MushroomColor {
	random, blue, bluegreen, brown, purple, yellow, 
}

export(MushroomColor) var mushroom_color = MushroomColor.yellow setget _set_mushroom_color
const mushroom_shapes_count := 9 # We cannot use this in values of `export` though, but we can use it in other code.
export(int, 0, 9) var mushroom_shape = 0 setget _set_mushroom_shape 
export var random_mushroom_shape := true
export var is_stuck_in_ground := true
export(float, 0.01, 100.0) var lightening_distance := 1.0 setget _set_lightening_distance

var _target_light_strengh : float

var _is_ready := false

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(_models_node)
	
	_lighten_area.connect("body_entered", self, "_on_player_is_close")
	_lighten_area.connect("body_exited", self, "_on_player_left")
	
	if is_stuck_in_ground:
		set_mode(RigidBody.MODE_STATIC) # We want the mushrooms to always be static until picked up.
		_cancel_velocity(self)
	
	if _light_node:
		_target_light_strengh = _light_node.light_energy
	
	_is_ready = true
	_update_mushroom()

func _update_mushroom() ->void :
	if not _is_ready:
		return
		
	_hide_all_models()
	if random_mushroom_shape:
		mushroom_shape = rand_range(0, mushroom_shapes_count - 1)
	_show_selected_model()
	_check_light_visibility()
#	print("Mushroom updated: %s" % name)

func _hide_node(node: Node)->void:
	if node is Spatial and not node is MeshInstance: # We don't want to hide the meshes, just their node ownders.
		node.visible = false

func _hide_all_models() -> void:
	utility.apply_recursively(_models_node, funcref(self, "_hide_node"), false)

func _show_selected_model() -> void:
	var color_name : String = "%s" % MushroomColor.keys()[mushroom_color]
	var color_node : Spatial = _models_node.get_node(color_name)
	assert(color_node is Node) # This is for crashing spectacularly if the node was not found.
	color_node.visible = true
	
	var mushroom_path = "mushroom_%d" % mushroom_shape
#	print("mushroom_path = %s/%s" % [ color_name, mushroom_path])
	var mushroom_node = color_node.get_node(mushroom_path)
	assert(mushroom_node is Node) # This is for crashing spectacularly if the node was not found.
	mushroom_node.visible = true
	
	# change the light color too
	if mushroom_color != MushroomColor.brown:
		var current_mesh : MeshInstance = mushroom_node.get_node("geo1")
		assert(current_mesh)
		current_mesh.cast_shadow = false # We want the mushroom to emit light without casting shadows on itself
		var current_hat_material : Material = current_mesh.mesh.surface_get_material(0)
		assert(current_hat_material)
		if _light_node:
			_light_node.light_color = current_hat_material.emission
	
func _set_mushroom_color(new_color: int) -> void:
	if new_color != mushroom_color || new_color == MushroomColor.random:
		if new_color == MushroomColor.random:
			new_color = rand_range(1, MushroomColor.keys().size())
		mushroom_color = new_color
		
		if _models_node is Spatial:
			_update_mushroom()
		
func _set_mushroom_shape(new_shape: int) -> void:
	
	if new_shape != mushroom_shape:
		mushroom_shape = new_shape
		if _models_node is Spatial:
			_update_mushroom()

func _check_light_visibility() -> void:
	if not _is_ready:
		return
		
	var shape : SphereShape = _lighten_area_shape.shape
	shape.radius = lightening_distance
	_lighten_area_shape.transform.origin = _lighten_area_shape.transform.origin
	for body in _lighten_area.get_overlapping_bodies():
		if _light_node and body is Player and mushroom_color != MushroomColor.brown and _light_node.visible == false:
			_light_node.visible = true
		else:
			_light_node.visible = false

func _on_player_is_close(player : Node) -> void:
	if _light_node and player is Player and mushroom_color != MushroomColor.brown and _light_node.visible == false:
		_player = player
		_light_node.visible = true

func _on_player_left(player: Node) -> void:
	if _light_node and player is Player and _light_node.visible == true:
		_player = null
		_light_node.visible = false

func _set_lightening_distance(new_value: float) -> void:
	lightening_distance = new_value
	_check_light_visibility()
	
func _process(delta):
	if _light_node and _player is Player:
		var player_distance = _player.global_transform.origin.distance_to(self.global_transform.origin)
		var distance_ratio = 1.0 - (player_distance / lightening_distance)
		_light_node.light_energy = lerp(0, _target_light_strengh, distance_ratio)
	
