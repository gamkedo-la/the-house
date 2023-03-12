extends StaticBody

export var is_open := false

onready var _animations : AnimationPlayer = $AnimationPlayer

func _ready():
	set_collision_layer_bit(CollisionLayers.player_interraction_raycast_layer_bit, true)

func player_interracts():
	if is_open:
		return
		
	open_chest()

func open_chest() -> void:
	_animations.play("lid-opening")
	is_open = true

