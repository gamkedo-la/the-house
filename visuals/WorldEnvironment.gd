extends WorldEnvironment


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bloom_tween: Tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(bloom_tween)
	bloom_tween.connect("tween_all_completed", self, "_bloom_tween_completed")
	bloom_tween.interpolate_property(environment, "glow_strength", 1, 1.09, 7.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
#	bloom_tween.start()
	pass # Replace with function body.

func _bloom_tween_completed() -> void:
	if environment.glow_strength > 1:
		var ignored = bloom_tween.interpolate_property(environment, "glow_strength", 1.09, 1, 7.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	else:
		var ignored = bloom_tween.interpolate_property(environment, "glow_strength", 1, 1.09, 7.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		
	var ignored = bloom_tween.start()
	
func _process(delta) -> void:
	if Input.is_action_just_pressed("debug_switch_fog"):
		environment.fog_enabled = not environment.fog_enabled
	if Input.is_action_just_pressed("debug_switch_glow"):
		environment.glow_enabled = not environment.glow_enabled
	
	
