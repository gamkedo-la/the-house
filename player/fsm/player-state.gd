extends FSM_State

class_name PlayerState


# Higher level actions the player can do, used to change the states:
enum Action {
	take_item,
	drop_item,
	examine_item,
	stop_examining_item
}

var player # : Player  set by the statemachine

func _init(id:String).(id) -> void:
	pass
