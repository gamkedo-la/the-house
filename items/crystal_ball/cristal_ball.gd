extends InteractiveItem

onready var _light_node : OmniLight = $"light"
onready var _sphere_node : MeshInstance = $"sphere"
onready var _audio_player := $audio_player

onready var _sound_on : AudioStream = load("res://audio/sounds/crystal-ball-on.mp3")
onready var _sound_off : AudioStream = load("res://audio/sounds/crystal-ball-off.mp3")

var _is_ready := false

func _ready():
	turn_off()

	_is_ready = true


func is_lighting() -> bool:
	return _light_node.visible

func turn_on() -> void:
	_sphere_node.get_active_material(0).emission_enabled = true
	_light_node.visible = true

	if _is_ready:
		_audio_player.stream = _sound_on
		_audio_player.play()

func turn_off() -> void:
	_sphere_node.get_active_material(0).emission_enabled = false
	_light_node.visible = false

	if _is_ready:
		_audio_player.stream = _sound_off
		_audio_player.play()

func switch_light() -> void:
	if is_lighting():
		turn_off()
	else:
		turn_on()

func _on_crystal_ball_use_item(_item) -> void:
	switch_light()
