tool
extends StaticBody

export var is_open := false setget _set_open_chest
export var is_locked := true

onready var _animations : AnimationPlayer = $AnimationPlayer

func _ready():
	set_collision_layer_bit(CollisionLayers.player_interraction_raycast_layer_bit, true)
	
	if Engine.editor_hint:
		_set_open_chest(is_open)

func player_interracts():
	if is_locked:
		_display_locked_description()
		return
		
	if is_open:
		close_chest()
	else:
		open_chest()

func _display_locked_description() -> void:
	global.current_player.examination_display.display_text_sequence([
		"This chest is locked. I need [b]a code[/b] to open it...\nThe human [b]feet[/b] screwed on it's lid seems to be part of a mechanism..."
	])
	
func on_player_end_pointing() -> void:
	if is_locked:
		global.current_player.examination_display.stop_display_sequence()

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
		
