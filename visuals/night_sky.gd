extends Viewport


func get_moon_color() -> Color:
	return $Sprite.material.get_shader_param("MoonColor")

