tool
extends Spatial

enum Mode { random, keep_as_specified }

onready var _mushroom_scene:= preload("res://items/mushroom.tscn")
onready var _mushroom_node : Spatial = $"mushrooms"	

export(Mode) var mode:= Mode.random
export var mushroom_count := 7	setget _set_mushroom_count
export(Mushroom.MushroomColor) var mushroom_color := Mushroom.MushroomColor.random setget _set_mushroom_color
export(Array) var mushrooms_specs : Array = []

class MushroomSpec:	
	export(Mushroom.MushroomColor) var color := Mushroom.MushroomColor.random setget _change_color
	export(int) var shape := randi() % Mushroom.mushroom_shapes_count setget _change_shape
	var mushroom : Mushroom setget _set_node

	func update_sync() -> void:
		if mushroom:
			mushroom.mushroom_color = color
			mushroom.mushroom_shape = shape

	func _change_color(new_color: int) -> void:
		color = new_color
		update_sync()

	func _change_shape(new_shape: int) -> void:
		shape = new_shape
		update_sync()

	func _set_node(new_node: Mushroom) -> void:
		mushroom = new_node
		update_sync()



func _ready():
	_update_mushrooms() 

func _update_mushrooms():
	if mode == Mode.random:
		_clear_all_mushrooms()
	
	var did_count_change := false

	assert(mushrooms_specs.size() == _mushroom_node.get_child_count())
	while _mushroom_node.get_child_count() > mushroom_count:
		did_count_change = true
		_remove_one_mushroom();
	
	assert(mushrooms_specs.size() == _mushroom_node.get_child_count())
	while _mushroom_node.get_child_count() < mushroom_count:
		did_count_change = true
		_add_one_mushroom();
	
	assert(mushrooms_specs.size() == _mushroom_node.get_child_count())

	for mushroom_spec in mushrooms_specs:
		mushroom_spec.color = mushroom_color
	
	if mode == Mode.random:
		for mushroom_spec in mushrooms_specs:
			mushroom_spec.shape = randi() % Mushroom.mushroom_shapes_count

	if did_count_change:
		_place_mushrooms()

func _add_one_mushroom():
	assert(mushrooms_specs.size() == _mushroom_node.get_child_count())
	
	var new_spec = MushroomSpec.new()
	mushrooms_specs.append(new_spec)
	var new_mushroom : Mushroom = _mushroom_scene.instance()
	_mushroom_node.add_child(new_mushroom)
	new_spec.mushroom = new_mushroom
	
	
	assert(mushrooms_specs.size() == _mushroom_node.get_child_count())

func _place_mushrooms():
	# FIXME: Temporary placement
	var idx := 0
	for mushroom in _mushroom_node.get_children():
		mushroom.transform.origin = Vector3.RIGHT * (idx * 0.5)
		++idx
		

func _remove_one_mushroom():
	assert(mushrooms_specs.size() == _mushroom_node.get_child_count())
	mushrooms_specs.remove(0)
	utility.delete_child(_mushroom_node, _mushroom_node.get_child(0))
	assert(mushrooms_specs.size() == _mushroom_node.get_child_count())

func _clear_all_mushrooms():
	assert(mushrooms_specs.size() == _mushroom_node.get_child_count())
	mushrooms_specs.clear()
	utility.delete_children(_mushroom_node)
	assert(mushrooms_specs.size() == _mushroom_node.get_child_count())

func _set_mushroom_count(new_count: int) -> void:
	mushroom_count = new_count
	if _mushroom_node != null:
		_update_mushrooms()		

func _set_mushroom_color(new_color: int) -> void:
	mushroom_color = new_color
	if _mushroom_node != null:
		_update_mushrooms()

