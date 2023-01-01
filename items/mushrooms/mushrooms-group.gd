tool
extends Spatial

enum Mode { random, keep_as_specified }

onready var _mushroom_scene:= preload("res://items/mushroom.tscn")
onready var _mushroom_node : Spatial = $"mushrooms"	

export(Mode) var mode:= Mode.random
export var mushroom_count := 7	setget _set_mushroom_count
export(Mushroom.MushroomColor) var mushroom_color := Mushroom.MushroomColor.random setget _set_mushroom_color


func _ready():
	_update_mushrooms() 

func _update_mushrooms():
	print("Updating mushrooms in group : %s" % name)
	
	if mode == Mode.random:
		_clear_all_mushrooms()
	
	var did_count_change := false

	while _mushroom_node.get_child_count() > mushroom_count:
		did_count_change = true
		_remove_one_mushroom();
	
	while _mushroom_node.get_child_count() < mushroom_count:
		did_count_change = true
		_add_one_mushroom();
	
	for mushroom in _mushroom_node.get_children():
		mushroom.mushroom_color = mushroom_color
	
	if mode == Mode.random:
		for mushroom in _mushroom_node.get_children():
			mushroom.mushroom_shape = randi() % Mushroom.mushroom_shapes_count

	if did_count_change == true:
		_place_mushrooms()

func _add_one_mushroom():	
	var new_mushroom : Mushroom = _mushroom_scene.instance()
	_mushroom_node.add_child(new_mushroom)
	if Engine.editor_hint:
		new_mushroom.set_owner(get_tree().get_edited_scene_root())
	
func _remove_one_mushroom():
	utility.delete_child(_mushroom_node, _mushroom_node.get_child(0))

func _clear_all_mushrooms():
	utility.delete_children(_mushroom_node)

func _set_mushroom_count(new_count: int) -> void:
	mushroom_count = new_count
	if _mushroom_node != null:
		_update_mushrooms()		

func _set_mushroom_color(new_color: int) -> void:
	mushroom_color = new_color
	if _mushroom_node != null:
		_update_mushrooms()

func _place_mushrooms():
	# FIXME: Temporary placement
	print("Re-placing mushrooms")
	var idx := 0
	for mushroom in _mushroom_node.get_children():
		var new_relative_position : Vector3 = Vector3.RIGHT * (idx * 0.5)
		mushroom.transform.origin = new_relative_position
		print("set mushroom %d to %s" % [idx, new_relative_position])
		idx += 1
		
