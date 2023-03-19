extends "res://furniture/doors/door_handle.gd"

onready var _lock : Area = $lock

func _ready() -> void:
	_lock.connect("body_entered", self, "_on_hand_entered")
	_lock.connect("body_exited", self, "_on_hand_removed")

func _on_hand_entered(hand) -> void:
	if hand is BodyHand and not hand is GoldenHand:
		global.current_player.examination_display.display_text_sequence(["This hand doesnt seem to fit that handle...I think it needs to be more solid."])
		
func _on_hand_removed(hand) -> void:
	if hand is BodyHand and not hand is GoldenHand:
		global.current_player.examination_display.stop_display_sequence()
