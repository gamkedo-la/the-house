tool
extends Spatial

class_name Door

export var is_open := false setget _set_open, _is_open
export var is_locked := false setget _set_locked, _is_locked

signal door_opened()
signal door_closed()
signal door_locked()
signal door_unlocked()

onready var _door : Spatial = $"main_mesh"
onready var _door_handle_1 : Spatial = $"main_mesh/door_handle_1"
onready var _door_handle_2 : Spatial = $"main_mesh/door_handle_2"
onready var _open_position : Spatial = $"open_position"
onready var _closed_position : Spatial = $"closed_position"

func _ready():
	_setup_door_handle(_door_handle_1)
	_setup_door_handle(_door_handle_2)
	_update_door_mesh_state()

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
	if is_locked:
		return
	is_open = true
	_update_door_mesh_state()
	emit_signal("door_opened")
	
func close() -> void:
	is_open = false
	_update_door_mesh_state()
	emit_signal("door_closed")

func _update_door_mesh_state() -> void:
	if not _door:
		return
		
	if is_open:
		_door.global_transform.origin = _open_position.global_transform.origin
		_door.global_transform.basis = _open_position.global_transform.basis
	else:
		_door.global_transform.origin = _closed_position.global_transform.origin
		_door.global_transform.basis = _closed_position.global_transform.basis

func _is_locked() -> bool:
	return is_locked

func _set_locked(should_be_locked:bool):
	if should_be_locked:
		lock()
	else:
		unlock()

func unlock() -> void:
	emit_signal("door_unlocked")
	is_locked = false
	
func lock() -> void:
	emit_signal("door_locked")
	is_locked = true

func on_player_interract():
	_set_open(not is_open)
	
