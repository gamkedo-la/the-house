extends Area

class_name ClimbingArea

func _ready():
	set_collision_mask_bit(CollisionLayers.climbing_area_collision_bit, true)
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.set_movement_mode(Player.MovementMode.Climbing)

func _on_body_exited(body: Node) -> void:
	if body is Player:
		body.set_movement_mode(Player.MovementMode.Walking)

