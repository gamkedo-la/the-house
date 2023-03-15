extends TextDisplayArea


func _process(_delta):
	if _player is Player:
		var item = _player.get_item_in_hand()
		if item is Mushroom and item.mushroom_color == Mushroom.MushroomColor.yellow:
			monitoring = false
			$"../examine_instructions".monitoring = true

