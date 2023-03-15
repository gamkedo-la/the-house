extends "res://items/body/hand.gd"

class_name BodyEar

func _ready():
	self.is_left_handed = rand_range(0, 100) > 50


