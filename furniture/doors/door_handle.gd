extends Spatial

# TODO: generalize this
signal on_player_interracts()

func player_interracts():
	emit_signal("on_player_interracts")

func is_interraction_action() -> bool:
	return true
