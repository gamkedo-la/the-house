extends Camera

func _process(_delta):
	if options.fov != self.fov and (not global.current_player or not global.current_player.is_examining()):
		self.fov = options.fov
