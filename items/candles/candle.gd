extends InteractiveItem

onready var _light : Node = $"light"
onready var _fire_area : Node = $"light/Flame/fire_area"

var _player : Player
var _displaying_instructions := false

func _ready() -> void:
	$instructions_area.set_collision_mask_bit(CollisionLayers.player_collision_layer_bit, true)
	$instructions_area.connect("body_entered", self, "_on_entered_instruction_area")
	$instructions_area.connect("body_exited", self, "_on_exited_instruction_area")

func light_on() -> void:
	print("turning light on")
	_light.show()
	_fire_area.on_fire_on()
	
func light_off() -> void:
#	print("turning light off")
	_light.hide()
	_fire_area.on_fire_off()
	
# TODO: add ways to make the candle turn off when mishandled

func _on_lightable_area_lit_using_fire() -> void:
	print("time to turn on through fire")
	_player.did_light_a_candle = true
	_stop_instructions()
	light_on()


func _on_Candle_use_item():
	light_off()
	
func _on_entered_instruction_area(player) -> void:
	if player is Player:
		_player = player
	
func _on_exited_instruction_area(player) -> void:
	if _player is Player:
		_stop_instructions()
		_player = null
		
func _process(_delta) -> void:
	if _player is Player and not _player.did_light_a_candle and _player.is_holding_item():
		var item = _player.get_item_in_hand()
		if not _displaying_instructions and utility.has_node_type("FireArea", item):
			_player.info_display.display_text_sequence(["Bring a flame close to the thread to light a candle."])
			_displaying_instructions = true 
			
func _stop_instructions() -> void:
	if _displaying_instructions:
		_displaying_instructions = false
		_player.info_display.stop_display_sequence()
