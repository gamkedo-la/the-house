extends AudioStreamPlayer3D

enum StepSurface {
	Grass, Dirt, House,
}

onready var step_sounds = {
	StepSurface.Grass : [
		preload("res://assets-workfiles/audio/footsteps/footstep_grass-01.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_grass-02.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_grass-03.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_grass-04.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_grass-05.wav"),
	],
	StepSurface.House : [
		preload("res://assets-workfiles/audio/footsteps/footstep_wood-01.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_wood-02.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_wood-03.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_wood-04.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_wood-05.wav"),
	],
	StepSurface.Dirt : [
		preload("res://assets-workfiles/audio/footsteps/footstep_hard-01.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_hard-02.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_hard-03.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_hard-04.wav"),
		preload("res://assets-workfiles/audio/footsteps/footstep_hard-05.wav"),
	]
}

const _step_interval_duration_ms := 500
var _last_step_time := 0
var _we_are_walking = false

func begin_walk():
	_we_are_walking = true
	
func end_walk():
	_we_are_walking = false
	
func _process(_delta):
	if _we_are_walking:
		update_step_sounds(_delta)
	

func update_step_sounds(_delta):
	var now = Time.get_ticks_msec()
	if _last_step_time + _step_interval_duration_ms < now:
		_last_step_time = now
		play_random_step(StepSurface.House)

func play_random_step(surface: int):
	var sound_bank = step_sounds[surface]
	var sound = utility.random_selection(sound_bank)
	assert(sound is AudioStream)
	stream = sound
	play()
	
