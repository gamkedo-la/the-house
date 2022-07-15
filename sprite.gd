extends Sprite


var speed = 400
var angular_speed = PI


func _process(delta):
	
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
	
	rotation += angular_speed * direction * delta
	
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * speed
		
	position += velocity * delta


func _on_Button_pressed():
	set_process(not is_processing())

func _ready():
	var timer = get_node("Timer")
	timer.connect("timeout", self, "_on_Timer_timeout")
	
func _on_Timer_timeout():
	visible = not visible
	
