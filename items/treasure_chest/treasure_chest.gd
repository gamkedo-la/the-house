tool
extends StaticBody

export var is_open := false setget _set_open_chest
export var is_keypad_locked := true
export var is_locked := true

onready var _animations : AnimationPlayer = $AnimationPlayer
onready var _lock_boot : LockArea = $"%foot_boot/lock"
onready var _lock_woman : LockArea = $"%foot_woman_shoe/lock"
onready var _lock_sports : LockArea = $"%foot_sports_shoe/lock"


func _ready():
	set_collision_layer_bit(CollisionLayers.player_interraction_raycast_layer_bit, true)

	_lock_boot.connect("unlocked", self, "_on_unlocked_any_lock")
	_lock_woman.connect("unlocked", self, "_on_unlocked_any_lock")
	_lock_sports.connect("unlocked", self, "_on_unlocked_any_lock")

	if Engine.editor_hint:
		_set_open_chest(is_open)

func _on_unlocked_any_lock(_key_name) -> void:
	global.current_player.action_display.display_text_sequence(["I can hear something [b]unlock[/b] inside the chest..."])
	if not _lock_boot.is_locked and not _lock_woman.is_locked and not _lock_sports.is_locked and not is_keypad_locked:
		global.current_player.action_display.display_text_sequence(["I think it was the last lock, I can probably open it now..."], TextDisplay.DisplayMode.ADD_NEXT)
		is_locked = false

func player_interracts():
	if is_locked:
		if is_keypad_locked:
			var item = global.current_player.get_item_in_hand()
			if item is PaperNote and item.is_translated:
				if item.note_key == "chest":
					_unlock_keypad()
				else:
					_display_wrong_code_description()
				return

		_display_locked_description()
		return

	if is_open:
		if Engine.editor_hint:
			close_chest()
	else:
		open_chest()

func _unlock_keypad() -> void:
	is_keypad_locked = false
	_on_unlocked_any_lock("keypad")

func _display_locked_description() -> void:
	global.current_player.examination_display.display_text_sequence([
		"This chest is locked. I need [b]a code[/b] to open it...\nThe human [b]feet[/b] screwed on it's lid seems to be part of a mechanism..."
	])

func _display_wrong_code_description() -> void:
	global.current_player.examination_display.display_text_sequence([
		"This code does not seem to work on this keypad..."
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

