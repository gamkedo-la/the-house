extends RichTextLabel

onready var _info = $"../debug_info"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("debug_info"):
		toggle_debug_info()

func toggle_debug_info():
	if visible:
		hide()
		_info.show()
	else:
		_info.hide()
		show()
