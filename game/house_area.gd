extends Area

onready var _forest := $"%forest"
onready var _forest_mushrooms := $"%forest/mushrooms"

func _ready() -> void:
	assert(_forest)
	assert(_forest_mushrooms)
	connect("body_entered", self, "on_player_entered")
	connect("body_exited", self, "on_player_exited")

func on_player_entered(player : Node) -> void:
	if player is Player:
		print("Removing all mushrooms from the forest...")
		_forest.remove_child(_forest_mushrooms)
		print("Removing all mushrooms from the forest - DONE")
		
func on_player_exited(player : Node) -> void:
	if player is Player:
		print("Re-adding all mushrooms to the forest...")
		_forest.add_child(_forest_mushrooms)
		print("Re-adding all mushrooms to the forest - DONe")
			
