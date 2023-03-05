tool
extends Door

var _player : Player
var _displaying_instructions := false

func _ready():
	find_node("lock").connect("unlocked", self, "_on_lock_unlocked")
	connect("notified_door_is_locked", self, "_on_notified_door_is_locked")
	$instructions_area.set_collision_mask_bit(CollisionLayers.player_collision_layer_bit, true)
	$instructions_area.connect("body_entered", self, "_on_entered_instruction_area")
	$instructions_area.connect("body_exited", self, "_on_exited_instruction_area")
	
func _on_lock_unlocked(_key_name):
	_player.did_unlock_using_a_key = true
	_player.did_try_to_open_door = true
	_stop_instructions()
	$instructions_area.monitoring = false
	unlock()


func _on_entered_instruction_area(player) -> void:
	if player is Player:
		_player = player
	
func _on_exited_instruction_area(player) -> void:
	if _player is Player:
		_stop_instructions()
		_player = null
		
func _process(_delta) -> void:
	if _player is Player and not _player.did_unlock_using_a_key:
		if not _displaying_instructions:
			var item = _player.get_item_in_hand()
			if item and utility.has_node_type("KeyArea", item):
				_player.info_display.display_text_sequence(["Bring a [b]key[/b] item [b]close to a lock[/b] to unlock it.\n[SPACE] -> [b]Hold item in front of you[/b]"])
				_displaying_instructions = true
			elif not _player.did_try_to_open_door:
				_player.info_display.display_text_sequence(["Left Mouse Button on a door knob -> [b]Open the door[/b]"])
				_displaying_instructions = true
			
func _stop_instructions() -> void:
	if _displaying_instructions:
		_displaying_instructions = false
		_player.info_display.stop_display_sequence()


func _on_notified_door_is_locked() -> void:
	if _player is Player:
		_player.did_try_to_open_door = true
		_stop_instructions()
