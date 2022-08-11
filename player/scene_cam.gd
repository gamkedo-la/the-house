extends Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	var iChannel = $Sky.get_viewport().get_texture()
	$WorldEnvironment.environment.background_sky.set_panorama(iChannel)
#	self.environment = env
#	self.environment.background_sky.set_panorama(iChannel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
