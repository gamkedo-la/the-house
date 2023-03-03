extends Spatial

var master_scene = null # Dont use this except if this is a scene below main when the game is normally running

onready var _main_menu : CanvasLayer = $"%main_menu"
onready var _options_screen : Node2D = $"%options_screen"
onready var _credits_screen : Node2D = $"%credits_screen"
onready var _loading : CanvasLayer =  $"%loading"

func _ready():
	$"%start_button".connect("pressed", self, "_start_new_game")


func _start_new_game():
	if master_scene:
		_main_menu.visible = false
		_loading.visible = true
		yield(get_tree().create_timer(0.1), "timeout")
		master_scene.start_new_game()
