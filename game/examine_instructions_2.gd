extends TextDisplayArea



func _process(_delta):
	if _player is Player and _player.is_examining() == false:
		monitoring = false
		$"../point_forward_instructions".monitoring = true
