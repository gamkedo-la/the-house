extends StaticBody

onready var _climbing_area = $"climbing_area"
onready var _collision_shape = $"CollisionShape"

func _ready():
	connect("visibility_changed", self, "_update_climbing_area")
	_update_climbing_area()

func _update_climbing_area() -> void:
	_climbing_area.monitoring = self.visible
	_climbing_area.monitorable = self.visible
	_collision_shape.disabled = not self.visible
