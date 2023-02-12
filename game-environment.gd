extends Spatial

func _ready():
	var iChannel = $"%Sky".get_viewport().get_texture()
	$"%WorldEnvironment".environment.background_sky.set_panorama(iChannel)
