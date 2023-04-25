extends Spatial

var master_scene = null # Dont use this except if this is a scene below main when the game is normally running

onready var _main_menu : CanvasLayer = $"%main_menu"
onready var _options_screen : CanvasLayer = $"%options_screen"
onready var _loading : CanvasLayer =  $"%loading"

func _ready():
	$"%start_button".connect("pressed", self, "_start_new_game")
	$"%credits_button".connect("pressed", self, "_to_credits")
	$"%options_button".connect("pressed", self, "_open_options")
	$"%feedback_button".connect("pressed", self, "_to_feedback")

	if OS.get_name() != "HTML5":
		$"%exit_button".connect("pressed", self, "_exit_game")
	else:
		$"%exit_button".visible = false
		$"%exit_button".disabled = true

	_options_screen.connect("on_back_from_options", self, "_close_options")


func _start_new_game():
	if master_scene:
		_main_menu.visible = false
		_loading.visible = true
		yield(get_tree().create_timer(0.1), "timeout")
		master_scene.start_new_game()

func _to_credits():
	if master_scene:
		_main_menu.visible = false
		master_scene.to_credits_screen()

func _open_options():
	_main_menu.visible = false
	_options_screen.visible = true

func _close_options():
	_options_screen.visible = false
	_main_menu.visible = true

func _to_feedback() -> void:
	OS.shell_open("https://docs.google.com/forms/d/e/1FAIpQLSfbbXndm304XRlLyVB00egftwFO2jWM0-kU4MJVz1wFH1vwuA/viewform")

func _exit_game():
	get_tree().quit()
