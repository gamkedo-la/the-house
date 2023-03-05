extends TextDisplayArea


func _process(_delta):
	if _player is Player and _player.is_holding_item():
		monitoring = false
		$"../examine_instructions".monitoring = true

