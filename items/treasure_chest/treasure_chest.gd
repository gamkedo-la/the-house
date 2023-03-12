tool
extends StaticBody

export var is_open := false setget _set_open_chest

onready var _animations : AnimationPlayer = $AnimationPlayer

func _ready():
	set_collision_layer_bit(CollisionLayers.player_interraction_raycast_layer_bit, true)
	
	if Engine.editor_hint:
		_set_open_chest(is_open)

func player_interracts():
	if is_open:
		close_chest()
	else:
		open_chest()

func open_chest() -> void:
	_animations.play("lid-opening")
	is_open = true

func close_chest() -> void:
	_animations.play("default")
	is_open = false

func _set_open_chest(new_value : bool) -> void:
	if new_value == is_open:
		return
		
	if new_value:
		open_chest()
	else:
		close_chest()
		
