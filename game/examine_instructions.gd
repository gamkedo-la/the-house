extends TextDisplayArea



func _process(_delta):
	if _player is Player and _player.is_examining():
		monitoring = false
		$"../examine_instructions2".monitoring = true


