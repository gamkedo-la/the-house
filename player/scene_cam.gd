extends Camera

onready var _pixelator : CanvasLayer = $"screen pixelation"
onready var _airdust : CPUParticles = $"airdust_particles"
onready var _environment : WorldEnvironment= $"%WorldEnvironment"


func _process(delta):
	# TEMPORARY:
	if Input.is_action_just_pressed("debug_switch_pixelator"):
		_pixelator.visible = not _pixelator.visible
		print("screen pixelation: ", _pixelator.visible)
	if Input.is_action_just_pressed("debug_switch_airdust"):
		_airdust.visible = not _airdust.visible
		print("air dust: ", _airdust.visible)
	if _environment:
		if Input.is_action_just_pressed("debug_switch_fog"):
			_environment.environment.fog_enabled = not _environment.environment.fog_enabled
			print("fog:  ", _environment.environment.fog_enabled)
		if Input.is_action_just_pressed("debug_switch_glow"):
			_environment.environment.glow_enabled = not _environment.environment.glow_enabled
			print("glow:  ", _environment.environment.glow_enabled)
	# END OF TEMPORARY
