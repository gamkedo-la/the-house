extends InteractiveItem

# TODO: generalize this
signal on_player_interracts()

func player_interracts():
	emit_signal("on_player_interracts")
