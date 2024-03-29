extends Node

signal player_ready
signal game_ready

var current_game : Game setget _set_game
var current_player : Player setget _set_player

var gravity := Vector3(0.0, -ProjectSettings.get_setting("physics/3d/default_gravity"), 0.0)

var cardboard_material_darker: Material = null # This is a hack to avoid duplicating  cardboard material more than once

const is_dev_mode := false

func _set_game(new_game: Game) -> void:
	current_game = new_game
	emit_signal("game_ready")

func _set_player(new_player: Player) -> void:
	current_player = new_player
	emit_signal("player_ready")


#
## warning-ignore:unused_signal
#signal shake(val)
## warning-ignore:unused_signal
#signal exit_game
#
#
#var player_node: Spatial = null
#
#var main_menu: bool = false
#
#var current_scene = null
#
##var main_menu_scn = "res://Scenes/UI/MainMenu/MainMenu.tscn"
##var level_one = "res://Scenes/Rooms/LevelCon01.tscn"
#
#var game_over: bool = false
#
#
#func _ready():
#	pause_mode = Node.PAUSE_MODE_PROCESS
#	var root = get_tree().get_root()
#	current_scene = root.get_child(root.get_child_count() - 1)
#
#
#
#func _unhandled_key_input(event):
#	if Input.is_action_just_pressed("ui_cancel"):
#		toggle_pause()
#
#	var muted = AudioServer.is_bus_mute(0)
#	if event.is_action_pressed("mute"):
#		AudioServer.set_bus_mute(0, !muted)
#
#
#func exit_game() -> void:
#	get_tree().quit()
#
#func goto_scene(path):
#	# Defer the load until the current scene is done executing code
#	print("Getting to goto_scene...")
#	call_deferred("_deferred_goto_scene", path)
#
#func _deferred_goto_scene(path):
#	current_scene.free()
#	var s = load(path)
#	current_scene = s.instance()
#	get_tree().get_root().add_child(current_scene)
#	get_tree().set_current_scene(current_scene)
#
#func toggle_pause():
#	get_tree().paused = !get_tree().paused
#
#
#func pause_game(pause: bool) -> void:
#	get_tree().paused = pause
#
#
#func reparent(child: Node, new_parent: Node):
#	if child:
#		var old_parent = child.get_parent()
#		if old_parent != new_parent:
#			old_parent.remove_child(child)
#			new_parent.add_child(child)
#	else:
#		print_debug("Global.gd: Attempt to reparent child node failed due to child being null.")
