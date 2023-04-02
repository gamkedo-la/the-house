extends Camera

func _process(_delta):
	if options.fov != self.fov:
		self.fov = options.fov
