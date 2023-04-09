extends Spatial

export var key_item_path : NodePath

onready var _giant_mouth = $"%giant_mouth"
onready var _giant_eye = $"%giant_eye"
var _dropped_the_key : bool = false

func _ready():
	_giant_eye.connect("on_eye_closed", self, "_on_eye_closed")
	$giant_thing_audio_area.connect("body_entered", self, "_on_player_entered")
	$giant_thing_audio_area.connect("body_exited", self, "_on_player_exited")

func _on_eye_closed() -> void:
	_giant_mouth.open_mouth()
	# make sure the "key" item falls down
	if not _dropped_the_key:
		var key_item : InteractiveItem = get_node(key_item_path)
		key_item.sleeping = false
		key_item.linear_velocity = global.gravity
		_dropped_the_key = true
		$audio_shoe.play()
		print("giant mouth: item dropped")

	yield(get_tree().create_timer(5.46), "timeout")
	_giant_mouth.close_mouth()
	_giant_eye.open_eye()

func _on_player_entered(player:Spatial) -> void:
	if player is Player:
		_giant_mouth.start_mumbling()

func _on_player_exited(player:Spatial) -> void:
	if player is Player:
		_giant_mouth.stop_mumbling()
