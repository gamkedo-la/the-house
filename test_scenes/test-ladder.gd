extends StaticBody

onready var _climbing_area = $"climbing_area"

func _ready():
	connect("visibility_changed", self, "_update_climbing_area")
	_update_climbing_area()

func _update_climbing_area() -> void:
	_climbing_area.set_deferred("monitoring", self.visible)
#	_climbing_area.set_deferred("monitorable", self.visible)
