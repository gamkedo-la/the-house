extends Sprite

export var speed : float = 1.0

func _process(delta) -> void:
	rotation += delta * speed
