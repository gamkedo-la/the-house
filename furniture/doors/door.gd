tool
extends Spatial


export var is_open := false setget _set_open, _is_open
export var is_locked := false setget _set_locked, _is_locked


onready var _door : Spatial = $"main_mesh"
onready var _door_handle_1 : Spatial = $"main_mesh/door_handle_1"
onready var _door_handle_2 : Spatial = $"main_mesh/door_handle_2"
onready var _open_position : Spatial = $"open_position"
onready var _closed_position : Spatial = $"closed_position"

func _ready():
	_setup_door_handle(_door_handle_1)
	_setup_door_handle(_door_handle_2)

func _setup_door_handle(door_handle:Spatial):
	door_handle.set_collision_layer_bit(CollisionLayers.player_interraction_raycast_layer_bit, true)
	door_handle.connect("on_player_interracts", self, "on_player_interract")

func _is_open() -> bool:
	return is_open

func _set_open(should_open:bool):
	if should_open:
		open()
	else:
		close()

func open() -> void:
	_door.global_transform.origin = _open_position.global_transform.origin
	_door.global_transform.basis = _open_position.global_transform.basis
	is_open = true
	
func close() -> void:
	_door.global_transform.origin = _closed_position.global_transform.origin
	_door.global_transform.basis = _closed_position.global_transform.basis
	is_open = false

func _is_locked() -> bool:
	return is_locked

func _set_locked(should_be_locked:bool):
	if should_be_locked:
		lock()
	else:
		unlock()

func unlock() -> void:
	pass
	
func lock() -> void:
	pass

func on_player_interract():
	print("ouch")
	_set_open(not is_open)
	

