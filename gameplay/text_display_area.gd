extends Area
class_name TextDisplayArea

# Use this to specify a space where the player will get a text displayed.

export(Array, String) var bbtext_to_display := ["This will be read by [b]the player[/b] once they enter this area."]
export var display_only_once := true
export var stop_display_on_exit := false
export var prioritary_text := true
export var is_action_text := false
export var time_to_display_secs := 0.0

var _player : Player
var _time_player_entered := 0.0
var _need_to_display = true
var _text_display_enabled = true


func _ready():
	set_collision_layer_bit(CollisionLayers.player_collision_layer_bit, true)
	set_collision_mask_bit(CollisionLayers.player_collision_layer_bit, true)
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
func _on_body_entered(player: Node) -> void:
	if not _player and player is Player: # The first check is to make sure we are not in the case where the player crouched
		print("player entered ", name)
		_player = player
		if time_to_display_secs <= 0.0:
			print("immediate display ", name)
			_start_display()
		else:
			print("delayed display ", name)
			_time_player_entered = utility.now_secs()
		

func _on_body_exited(player: Node) -> void:
	if _player and player is Player:
		# Sometimes the player is just switching betweent crouched and standing up,
		# we need to make sure they left the area and didnt just do that.
		if player.did_crouch_changed_this_frame:
			return
		
		print("player exited ", name)
		
		if stop_display_on_exit:
			print("stop_display_on_exit")
			if is_action_text:
				player.stop_action_text_display()
			else:
				player.stop_text_display()
		if not display_only_once:
			print("reset for display ", name)
			_need_to_display = true
		_player = null

func _start_display() -> void:
	if _text_display_enabled and _need_to_display:
		if is_action_text:
			print("action text %s : %s", name, bbtext_to_display)
			_player.display_action_text_sequence(bbtext_to_display, prioritary_text)
		else:
			print("story text %s : %s", name, bbtext_to_display)
			_player.display_text_sequence(bbtext_to_display, prioritary_text)
		_need_to_display = false

func stop_text_display() -> void:
	_text_display_enabled = false

func _process(_delta) -> void:
	if _player and time_to_display_secs > 0.0:
		var time_since_start = utility.now_secs() - _time_player_entered
		if time_since_start >= time_to_display_secs:
			_start_display()
