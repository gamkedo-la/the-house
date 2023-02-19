extends Area

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(player: Node) -> void:
	if player is Player:
		$"to_disappear".visible = false
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)


