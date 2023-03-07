extends AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready():
	play(rand_range(0.0, stream.get_length()))
