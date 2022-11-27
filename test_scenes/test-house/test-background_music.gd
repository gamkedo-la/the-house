extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var initial_track := "res://audio/music-intro-draft1.mp3"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stream(load(initial_track))
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
