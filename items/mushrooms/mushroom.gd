
tool

extends InteractiveItem
class_name Mushroom


onready var _models_node : Spatial = $"models"
onready var _light_node : OmniLight = $"light"

enum MushroomColor {
	random, blue, bluegreen, brown, purple, yellow, 
}

export(MushroomColor) var mushroom_color = MushroomColor.yellow setget _set_mushroom_color
const mushroom_shapes_count := 9 # We cannot use this in values of `export` though, but we can use it in other code.
export(int, 0, 9) var mushroom_shape = 0 setget _set_mushroom_shape 
export var is_stuck_in_ground := true

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(_models_node)
	
	if is_stuck_in_ground:
		set_mode(RigidBody.MODE_STATIC) # We want the mushrooms to always be static until picked up.
	
	_cancel_velocity(self)
	_update_mushroom()

func _update_mushroom() ->void :
	_hide_all_models()
	_show_selected_model()
#	print("Mushroom updated: %s" % name)

func _hide_node(node: Node)->void:
	if node is Spatial and not node is MeshInstance: # We don't want to hide the meshes, just their node ownders.
		node.visible = false

func _hide_all_models() -> void:
	utility.apply_recursively(_models_node, funcref(self, "_hide_node"), false)

func _show_selected_model() -> void:
	var color_name : String = "%s" % MushroomColor.keys()[mushroom_color]
	var color_node : Spatial = _models_node.find_node(color_name)
	assert(color_node is Node) # This is for crashing spectacularly if the node was not found.
	color_node.visible = true
	
	var mushroom_path = "mushroom_%d" % mushroom_shape
#	print("mushroom_path = %s/%s" % [ color_name, mushroom_path])
	var mushroom_node = color_node.find_node(mushroom_path)
	assert(mushroom_node is Node) # This is for crashing spectacularly if the node was not found.
	mushroom_node.visible = true
	
	# change the light color too
	var current_mesh : MeshInstance = color_node.find_node("geo1")
	assert(current_mesh)
	var current_hat_material : Material = current_mesh.mesh.surface_get_material(0)
	assert(current_hat_material)
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
		
